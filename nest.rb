class Nest < Formula
  desc "The Neural Simulation Tool"
  homepage "http://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/releases/download/v2.12.0/nest-2.12.0.tar.gz"
  sha256 "bac578f38bb0621618ee9d5f2f1febfee60cddc000ff32e51a5f5470bb3df40d"
  revision 2
  head "https://github.com/nest/nest-simulator.git"

  bottle do
    sha256 "f42ee31af3192a861fdae4b89529b01be87f3e799031c16ea9c6d530c7c5f874" => :sierra
    sha256 "3e57652f4c9b5b9060406731953a4522839c93eab0c9ef1f3bbcd15dd4b958d2" => :el_capitan
    sha256 "ac249cdb725be9233fb1d0339dcf1cd119d657e64816b58bffaa5265918d1eb4" => :yosemite
    sha256 "254e6cc197a621530ce5d510eea1034a00ed599d034357611babba873bbfefec" => :x86_64_linux
  end

  option "with-python", "Build Python2 bindings (PyNEST)."
  option "with-python3", "Build Python3 bindings (PyNEST, precedence over --with-python)."
  option "without-openmp", "Build without OpenMP support."
  needs :openmp if build.with? "openmp"

  depends_on "gsl" => :recommended
  depends_on :mpi => [:optional, :cc, :cxx]

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b7/67/7e2a817f9e9c773ee3995c1e15204f5d01c8da71882016cac10342ef031b/Cython-0.25.2.tar.gz"
    sha256 "f141d1f9c27a07b5a93f7dc5339472067e2d7140d1c5a9e20112a5665ca60306"
  end

  # Any Python >= 2.7 < 3.x is okay (either from macOS or brewed)
  depends_on :python => :optional
  if build.with? "python"
    depends_on "numpy"
    depends_on "scipy"
    depends_on "matplotlib"
    depends_on "nose" => :python
  end

  depends_on :python3 => :optional
  if build.with? "python3"
    depends_on "numpy" => "with-python3"
    depends_on "scipy" => "with-python3"
    depends_on "matplotlib" => "with-python3"
    depends_on "nose" => :python3
  end

  depends_on "libtool" => :run
  depends_on "readline" => :run
  depends_on "cmake" => :build

  fails_with :clang do
    cause <<-EOS.undent
      Building NEST with clang is not stable. See https://github.com/nest/nest-simulator/issues/74 .
    EOS
  end

  def install
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")

    args = ["-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"]

    args << "-Dwith-mpi=ON" if build.with? "mpi"
    args << "-Dwith-openmp=OFF" if build.without? "openmp"
    args << "-Dwith-gsl=OFF" if build.without? "gsl"

    if build.with? "python3"
      args << "-Dwith-python=3"

      # Add local build resource Cython residing in buildpath to paths, with correct python version
      pyver = Language::Python.major_minor_version "python3"
      ENV.prepend_create_path "PATH", buildpath/"cython/bin"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python#{pyver}/site-packages"

      resource("Cython").stage do
        system "python3", *Language::Python.setup_install_args(buildpath/"cython")
      end
    elsif build.with? "python"
      dylib = OS.mac? ? "dylib" : "so"
      py_prefix = `python-config --prefix`.chomp
      py_lib = "#{py_prefix}/lib"

      args << "-Dwith-python=2"
      args << "-DPYTHON_LIBRARY=#{py_lib}/libpython2.7.#{dylib}"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python2.7"

      pyver = Language::Python.major_minor_version "python"
      ENV.prepend_create_path "PATH", buildpath/"cython/bin"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python#{pyver}/site-packages"

      resource("Cython").stage do
        system "python", *Language::Python.setup_install_args(buildpath/"cython")
      end
    else
      args << "-Dwith-python=OFF"
    end

    # "out of source" build
    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    # simple check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # necessary for the python tests
    ENV["exec_prefix"] = prefix
    # if build.head? does not seem to work
    if !File.directory?(pkgshare/"sources")
      # Skip tests for correct copyright headers
      ENV["NEST_SOURCE"] = "SKIP"
    else
      # necessary for one regression on the sources
      ENV["NEST_SOURCE"] = pkgshare/"sources"
    end

    if build.with? "mpi"
      # we need the command /mpirun defined for the mpi tests
      # and since we are in the sandbox, we create it again
      nestrc = <<-EOS
        /mpirun
        [/integertype /stringtype /stringtype]
        [/numproc     /executable /scriptfile]
        {
         () [
          (mpirun -np ) numproc cvs ( ) executable ( ) scriptfile
         ] {join} Fold
        } Function def
      EOS
      File.open(ENV["HOME"]+"/.nestrc", "w") { |file| file.write(nestrc) }
    end

    # run all tests
    args = []
    args << "--test-pynest" if build.with?("python") || build.with?("python3")
    if build.with? "python3"
      ENV["PYTHON"] = "python3"
    end
    system pkgshare/"extras/do_tests.sh", *args
  end
end
