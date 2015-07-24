class Cantera < Formula
  homepage "https://github.com/Cantera/cantera"
  url "https://github.com/Cantera/cantera/releases/download/v2.2.0/cantera-2.2.0.tar.gz"
  sha256 "306c218500eaabdf1e920601348d2b3acc1fb66b02eea842d98b3fbb41ebbc78"
  head "https://github.com/cantera/cantera.git"

  bottle do
    sha256 "6e5847b2a338a0de5fa734a646c4deb3c48767031613ac7033e0430f7bed620a" => :yosemite
    sha256 "e77a16a8ab7c58cf059aa02d6bcdf1cfe54ff73f9037ca408960a39a3bf30e05" => :mavericks
    sha256 "b83be1f05c2c3b98b6a8167756bf03ef0ad7401d38d30123d1f0307bcb885ad0" => :mountain_lion
  end

  option "with-matlab=", "Path to Matlab root directory"
  option "without-check", "Disable build-time checking (not recommended)"

  depends_on "scons" => :build
  depends_on :python if OS.mac? && MacOS.version <= :snow_leopard
  depends_on "numpy" => :python
  depends_on "sundials" => :recommended
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
    build_args << "matlab_path=" + matlab_path if matlab_path
    build_args << "python3_package=" + (build.with?("python3") ? "y" : "n")

    scons "build", *build_args
    scons "test" if build.with? "check"
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
