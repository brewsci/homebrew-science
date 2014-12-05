require 'formula'

class Vigra < Formula
  homepage 'http://hci.iwr.uni-heidelberg.de/vigra/'
  url 'https://github.com/ukoethe/vigra/releases/download/Version-1-10-0/vigra-1.10.0-src-with-docu.tar.gz'
  sha1 '0a882bc09f5a6ec1f8381ff571020259eb88ee67'
  head 'https://github.com/ukoethe/vigra.git'
  revision 1

  option :cxx11
  option "without-check", "skip tests"

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
      system "make", "check" if build.with? "check"
      system "make", "install"
    end
  end

  def caveats
    s = ""
    libtiff = Formula["libtiff"]
    libtiff_cxx11 = Tab.for_formula(libtiff).cxx11?
    if (build.cxx11? and not libtiff_cxx11) or (libtiff_cxx11 and not build.cxx11?)
      s += <<-EOS.undent
      The Homebrew warning about libtiff not being built with the C++11
      standard may be safely ignored as Vigra only relies on C API of libtiff.
      EOS
    end
    return s
  end
end
