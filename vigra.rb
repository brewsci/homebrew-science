class Vigra < Formula
  include Language::Python::Virtualenv
  desc "Image processing and analysis library"
  homepage "https://ukoethe.github.io/vigra/"
  url "https://github.com/ukoethe/vigra/releases/download/Version-1-11-1/vigra-1.11.1-src.tar.gz"
  sha256 "a5564e1083f6af6a885431c1ee718bad77d11f117198b277557f8558fa461aaf"
  head "https://github.com/ukoethe/vigra.git"

  bottle do
    cellar :any
    sha256 "48e9b5c24627169645de6b69eb7afa4e75e19ce81800f4b1753f37865f486caf" => :sierra
    sha256 "61e16f74e6d9c110135ecd9e9de7ab889b8d1029b09b3590e7a3e64cab29719e" => :el_capitan
    sha256 "0dedb6e0afa4e0cd1d0955ff3b356f35c13527934ec2593db9141576617209b4" => :yosemite
    sha256 "062d1a6b326086d1b603f25cf82b0008998a732e9b9c6358e2265a2506beae1f" => :x86_64_linux
  end

  option :cxx11
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
    url "https://pypi.python.org/packages/a5/16/8a678404411842fe02d780b5f0a676ff4d79cd58f0f22acddab1b392e230/numpy-1.12.1.zip"
    sha256 "a65266a4ad6ec8936a1bc85ce51f8600634a31a258b722c9274a80ff189d9542"
  end

  # vigra python bindings requires boost-python
  # see http://packages.ubuntu.com/saucy/python-vigra
  if build.with? "python"
    if build.cxx11?
      depends_on "boost-python" => "c++11"
    else
      depends_on "boost-python"
    end
  end

  def install
    if build.with? "python"
      venv = virtualenv_create(libexec)
      venv.pip_install resources
    end

    ENV.cxx11 if build.cxx11?
    ENV.append "CXXFLAGS", "-ftemplate-depth=512" if build.cxx11?
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
