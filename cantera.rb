class Cantera < Formula
  desc "chemical kinetics, thermodynamics, and transport process tool suite"
  homepage "https://github.com/Cantera/cantera"
  url "https://github.com/Cantera/cantera/archive/v2.2.1.tar.gz"
  sha256 "c7bca241848f541466f56e479402521c618410168e8983e2b54ae48888480e1e"
  revision 1
  head "https://github.com/cantera/cantera.git"

  bottle do
    sha256 "37db92af5748d559228cfb16a5a372d55229ab32e8d1dae7536395b2c0cd3a24" => :sierra
    sha256 "79c10dc1a46525796b667f5e2c09c3ee7eff5f2c125dd03bcadbaf700b84cbfe" => :el_capitan
    sha256 "f7fe0a187453fc9a01be6ec3eeb3d6894aee0ced36f753eada360791bb042acd" => :yosemite
  end

  option "with-matlab=", "Path to Matlab root directory"
  option "without-test", "Disable build-time testing (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on "scons" => :build
  depends_on :python if OS.mac? && MacOS.version <= :snow_leopard
  depends_on "numpy" => :python
  depends_on "sundials" => ["without-mpi", :recommended]
  depends_on "graphviz" => :optional
  depends_on :python3 => :optional

  resource "Cython" do
    url "https://pypi.python.org/packages/2f/ae/0bb6ca970b949d97ca622641532d4a26395322172adaf645149ebef664eb/Cython-0.25.1.tar.gz"
    sha256 "e0941455769335ec5afb17dee36dc3833b7edc2ae20a8ed5806c58215e4b6669"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python2.7/site-packages"
    resource("Cython").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"cython") << "--no-cython-compile"
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
    if build.with? "test"
      if !matlab_path
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
