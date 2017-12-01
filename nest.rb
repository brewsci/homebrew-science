class Nest < Formula
  desc "The Neural Simulation Tool"
  homepage "http://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/archive/v2.14.0.tar.gz"
  sha256 "afaf7d53c2d5305fac1257759cc0ea6d62c3cebf7d5cc4a07d4739af4dbb9caf"
  head "https://github.com/nest/nest-simulator.git"

  bottle do
    sha256 "dc8f3ebf2f9ad0175aac965c09993896401e5f514145530c8062f2601e91e2b8" => :high_sierra
    sha256 "2a798c462198ac0d2d6c780633b287f826958047df6028842e2a126b80014da9" => :sierra
    sha256 "de88b980a8997f4f0c126c117b19236655b739399134a7993f65f1dfb840e53e" => :el_capitan
    sha256 "77501fc7887e6debe3a6fc99ae78fe1e130e397af40cdaf091fb85a8ab4507a8" => :x86_64_linux
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
    url "https://files.pythonhosted.org/packages/ee/2a/c4d2cdd19c84c32d978d18e9355d1ba9982a383de87d0fcb5928553d37f4/Cython-0.27.3.tar.gz"
    sha256 "6a00512de1f2e3ce66ba35c5420babaef1fe2d9c43a8faab4080b0dbcc26bc64"
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
    # The Homebrew site-packages path is automatically added to the PYTHONPATH
    # env var in Library/Homebrew/requirements/python_requirement.rb. However,
    # it is getting confused as to which version of Python we are using and
    # putting the wrong site-packages on the path (2 instead of 3). Since we
    # don't need any Homebrew-installed bindings it is easiest/safe just to
    # delete it.
    ENV.delete("PYTHONPATH")

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

    # Replace internally accessible gcc with externally accesible version
    # in nest-config
    if OS.mac? || build.without?("mpi")
      inreplace bin/"nest-config",
          %r{#{HOMEBREW_REPOSITORY}/Library/Homebrew/shims.*/super},
          "#{HOMEBREW_PREFIX}/bin"
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
