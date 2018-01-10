class Vigra < Formula
  include Language::Python::Virtualenv
  desc "Image processing and analysis library"
  homepage "https://ukoethe.github.io/vigra/"
  url "https://github.com/ukoethe/vigra/releases/download/Version-1-11-1/vigra-1.11.1-src.tar.gz"
  sha256 "a5564e1083f6af6a885431c1ee718bad77d11f117198b277557f8558fa461aaf"
  revision 2
  head "https://github.com/ukoethe/vigra.git"

  bottle do
    cellar :any
    sha256 "e1c0c61673b0d83abe655959b5b812468ad7b44e079c17f6c67d89d7f20ca6fb" => :sierra
    sha256 "f5229d63afd14beba5bf805e37e37ac00ff0de61518b09a0e5f44cb2442449fd" => :el_capitan
    sha256 "f019c2eb3d7f11a24744da9f9a09041e8ee95a39ba1e846cbea349b370ccd6b8" => :yosemite
    sha256 "0ba6450f9069c7564cd97bd97e1c6537439a8623f1d4f1e2d9c1521f6c17015e" => :x86_64_linux
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
  # see https://packages.ubuntu.com/saucy/python-vigra
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
