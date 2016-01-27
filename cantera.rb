class Cantera < Formula
  homepage "https://github.com/Cantera/cantera"
  url "https://github.com/Cantera/cantera/releases/download/v2.2.0/cantera-2.2.0.tar.gz"
  sha256 "306c218500eaabdf1e920601348d2b3acc1fb66b02eea842d98b3fbb41ebbc78"
  head "https://github.com/cantera/cantera.git"
  revision 1

  bottle do
    sha256 "9a908f9f3577ef3aca702176dec9cbaf6a48ad8c2c01761779ee2a664ac69668" => :el_capitan
    sha256 "73c7391e0f64da7cd0dae280123f4026573e5a3e812f57621cac0ae1fc8d33ed" => :yosemite
    sha256 "d481191156eccb211a9b5301b575fd0c5ab305d78b97f2a72a07b12d06a95858" => :mavericks
  end

  option "with-matlab=", "Path to Matlab root directory"
  option "without-check", "Disable build-time checking (not recommended)"

  depends_on "scons" => :build
  depends_on :python if OS.mac? && MacOS.version <= :snow_leopard
  depends_on "numpy" => :python
  depends_on "sundials" => ["without-mpi", :recommended]
  depends_on "graphviz" => :optional
  depends_on :python3 => :optional

  resource "Cython" do
    url "https://pypi.python.org/packages/source/C/Cython/cython-0.22.tar.gz"
    sha256 "14307e7a69af9a0d0e0024d446af7e51cc0e3e4d0dfb10d36ba837e5e5844015"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python2.7/site-packages"
    resource("Cython").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"cython")
    end

    build_args = ["prefix=#{prefix}",
                  "python_package=full",
                  "CC=#{ENV.cc}",
                  "CXX=#{ENV.cxx}",
                  "f90_interface=n"]

    matlab_path = ARGV.value("with-matlab")
    if matlab_path
      build_args << "matlab_path=" + matlab_path
      # Matlab doesn't play nice with system Sundials installation
      if build.head?
        build_args << "system_sundials=n" # Cantera 2.3+
      else
        build_args << "use_sundials=n" # Cantera 2.2.x
      end
    end

    build_args << "python3_package=" + (build.with?("python3") ? "y" : "n")

    scons "build", *build_args
    if build.with? "check"
      if not matlab_path
        scons "test"
      else
        # Matlab test stalls when run through Homebrew, so run other sub-tests explicitly
        scons "test-general", "test-thermo", "test-kinetics", "test-transport", "test-python2"
      end
    end
    scons "install"
  end

  test do
    pythons = ["python"]
    pythons << "python3" if build.with? "python3"
    pythons.each do |python|
      # Run those portions of the test suite that do not depend of data
      # that's only available in the source tree.
      system(python, "-m", "unittest", "-v",
             "cantera.test.test_transport",
             "cantera.test.test_purefluid",
             "cantera.test.test_mixture")
    end
  end
end
