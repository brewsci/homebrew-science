class Vigra < Formula
  include Language::Python::Virtualenv
  desc "Image processing and analysis library"
  homepage "https://ukoethe.github.io/vigra/"
  url "https://github.com/ukoethe/vigra/releases/download/Version-1-11-1/vigra-1.11.1-src.tar.gz"
  sha256 "a5564e1083f6af6a885431c1ee718bad77d11f117198b277557f8558fa461aaf"
  revision 1
  head "https://github.com/ukoethe/vigra.git"

  bottle do
    cellar :any
    sha256 "fa6b63d6a57483a09cb237ff30b6b4a4430bbd08417a487f787f4a9acfcdfb3d" => :sierra
    sha256 "d14d0c4ebd601a8a96cebd710f97c60b68a6d7033c6546eb2eac777e328e5a8b" => :el_capitan
    sha256 "302beaed5d5cbb5e6e238acf7f9f1a3fad7e52f013278d3d0b770a459f50c578" => :yosemite
    sha256 "f8753ffd3171bccda7e32b56702ca7a5ae69b3565ee6e682be82f8313a243b87" => :x86_64_linux
  end

  needs :cxx11
  option "without-test", "skip tests"

  deprecated_option "without-check" => "without-test"

  depends_on :python => :optional
  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "hdf5" => :recommended
  depends_on "fftw" => :recommended
  depends_on "openexr" => :optional

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/a5/16/8a678404411842fe02d780b5f0a676ff4d79cd58f0f22acddab1b392e230/numpy-1.12.1.zip"
    sha256 "a65266a4ad6ec8936a1bc85ce51f8600634a31a258b722c9274a80ff189d9542"
  end

  # vigra python bindings requires boost-python
  # see http://packages.ubuntu.com/saucy/python-vigra
  depends_on "boost-python" => "c++11" if build.with? "python"

  def install
    if build.with? "python"
      venv = virtualenv_create(libexec)
      venv.pip_install resources
    end

    ENV.cxx11
    ENV.append "CXXFLAGS", "-ftemplate-depth=512"
    cmake_args = std_cmake_args
    cmake_args << "-DWITH_VIGRANUMPY=0" if build.without? :python
    cmake_args << "-DWITH_HDF5=0" if build.without? "hdf5"
    cmake_args << "-DWITH_OPENEXR=1" if build.with? "openexr"
    cmake_args << "-DVIGRANUMPY_INSTALL_DIR=#{lib}/python2.7/site-packages" if build.with? :python
    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "check" if build.with? "test"
      system "make", "install"
    end
  end

  def caveats
    s = ""
    libtiff = Formula["libtiff"]
    libtiff_cxx11 = Tab.for_formula(libtiff).cxx11?
    if (build.cxx11? && !libtiff_cxx11) || (libtiff_cxx11 && !build.cxx11?)
      s += <<-EOS.undent
      The Homebrew warning about libtiff not being built with the C++11
      standard may be safely ignored as Vigra only relies on C API of libtiff.
      EOS
    end
    s
  end
end
