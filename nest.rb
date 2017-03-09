class Nest < Formula
  desc "The Neural Simulation Tool"
  homepage "http://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/releases/download/v2.12.0/nest-2.12.0.tar.gz"
  sha256 "6b5ca7680f758bdd44047e23faea5708b2de2e253574807b1ba98dbcdf1ea813"
  revision 1
  head "https://github.com/nest/nest-simulator.git"

  bottle do
    sha256 "d3bbd61af1d42ecd02e6d00cad49083003e14f4b3b017381120e48271e944b62" => :sierra
    sha256 "e6936bb40ba34cfa36d4b7ae796f4478aeb380b08f34d5f5fd4e3635b8fed9b3" => :el_capitan
    sha256 "536875e5baedb4d36889af07b1506ce4c53fd33952304ffaaa4ced624e287165" => :yosemite
  end

  option "with-python", "Build Python2 bindings (PyNEST)."
  option "with-python3", "Build Python3 bindings (PyNEST, precedence over --with-python)."
  option "without-openmp", "Build without OpenMP support."
  needs :openmp if build.with? "openmp"

  depends_on "gsl" => :recommended
  depends_on :mpi => [:optional, :cc, :cxx]

  # Any Python >= 2.7 < 3.x is okay (either from macOS or brewed)
  depends_on :python => :optional
  if build.with? "python"
    depends_on "numpy"
    depends_on "scipy"
    depends_on "matplotlib"
    depends_on "cython" => [:python, :build]
    depends_on "nose" => :python
  end

  depends_on :python3 => :optional
  if build.with? "python3"
    depends_on "numpy"
    depends_on "scipy"
    depends_on "matplotlib"
    depends_on "cython" => [:python3, :build]
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
