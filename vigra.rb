class Vigra < Formula
  desc "Image processing and analysis library"
  homepage "https://ukoethe.github.io/vigra/"
  url "https://github.com/ukoethe/vigra/releases/download/Version-1-11-0/vigra-1.11.0-src.tar.gz"
  sha256 "68617de347eae7d4700a8f66cd59ce31d6cd92ffb4a235b4df34c688673af5cb"
  head "https://github.com/ukoethe/vigra.git"

  bottle do
    cellar :any
    sha256 "3aa7a33ae3f131a46afacb98ed935aca16a8b8d220c2aa5357f34f9c00e3ada6" => :sierra
    sha256 "68b480cd2c1cae02beac2cb0ac66f7a06cc5d1904e2d847be8140f7af4b00031" => :el_capitan
    sha256 "4b61b3e25a1a0d8196474e1778d3eb38df6e67f3ef363f9e21c73a5548757062" => :yosemite
  end

  option :cxx11
  option "without-test", "skip tests"

  deprecated_option "without-check" => "without-test"

  depends_on :python => :optional
  depends_on "numpy" => :python if build.with? :python
  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "hdf5" => :recommended
  depends_on "fftw" => :recommended
  depends_on "openexr" => :optional

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
