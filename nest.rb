class Nest < Formula
  desc "The Neural Simulation Tool"
  homepage "http://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/releases/download/v2.12.0/nest-2.12.0.tar.gz"
  sha256 "bac578f38bb0621618ee9d5f2f1febfee60cddc000ff32e51a5f5470bb3df40d"
  revision 3
  head "https://github.com/nest/nest-simulator.git"

  bottle do
    sha256 "bbb4797c44512f1ee6dab6820de01abe02980b7934dadcac202e4750eb98433a" => :high_sierra
    sha256 "599a8cc798de6efa5dcfb121c70e707c78f3baf3712b2d2ab8f360ee6ca72ab3" => :sierra
    sha256 "21316f8433df5b20a661e82b0c232d9e29253b2492c917fd5141df13fc0b88cf" => :el_capitan
    sha256 "bad1e499da5f6a627a26194ca9607256f64e6c0ccc6644bf82c93f7e31ed290b" => :x86_64_linux
  end

  option "with-python", "Build Python2 bindings (PyNEST)."
  option "with-python3", "Build Python3 bindings (PyNEST, precedence over --with-python)."
  option "without-openmp", "Build without OpenMP support."
  needs :openmp if build.with? "openmp"

  depends_on "gsl" => :recommended
  depends_on :mpi => [:optional, :cc, :cxx]

  # Any Python >= 2.7 < 3.x is okay (either from macOS or brewed)
  depends_on :python => :optional
  depends_on :python3 => :optional
  if build.with?("python") || build.with?("python3")
    requires_py3 = []
    requires_py3 << "with-python3" if build.with? "python3"
    depends_on "numpy" => requires_py3
    depends_on "scipy" => requires_py3
    depends_on "matplotlib" => requires_py3
  end

  depends_on "libtool" => :run
  depends_on "readline" => :run
  depends_on "cmake" => :build

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b7/67/7e2a817f9e9c773ee3995c1e15204f5d01c8da71882016cac10342ef031b/Cython-0.25.2.tar.gz"
    sha256 "f141d1f9c27a07b5a93f7dc5339472067e2d7140d1c5a9e20112a5665ca60306"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

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
    elsif build.with? "python"
      dylib = OS.mac? ? "dylib" : "so"
      py_prefix = `python-config --prefix`.chomp
      py_lib = "#{py_prefix}/lib"

      args << "-Dwith-python=2"
      args << "-DPYTHON_LIBRARY=#{py_lib}/libpython2.7.#{dylib}"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python2.7"
    else
      args << "-Dwith-python=OFF"
    end

    Language::Python.each_python(build) do |python, version|
      dest_path = lib/"python#{version}/site-packages"
      dest_path.mkpath
      resource("nose").stage do
        system python, *Language::Python.setup_install_args(libexec/"nose")
        # only nose executable is interesting during testing - not adding a *.pth file
      end

      # Add local build resource Cython residing in buildpath to paths
      ENV.prepend_create_path "PATH", buildpath/"cython/bin"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python#{version}/site-packages"

      resource("Cython").stage do
        system python, *Language::Python.setup_install_args(buildpath/"cython")
      end
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
    if build.with?("python") || build.with?("python3")
      args << "--test-pynest"
      # add nosetest executable to path
      ENV.prepend_create_path "PATH", libexec/"nose/bin"
    end

    ENV["PYTHON"] = "python3" if build.with? "python3"

    system pkgshare/"extras/do_tests.sh", *args
  end
end
