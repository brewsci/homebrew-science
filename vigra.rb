require 'formula'

class Vigra < Formula
  homepage 'http://hci.iwr.uni-heidelberg.de/vigra/'
  #url 'https://github.com/ukoethe/vigra/archive/Version-1-10-0.tar.gz'
  #sha1 'fb0a2e5ba727e59c64a60dc5fab9c807927fc869'
  url 'https://github.com/ukoethe/vigra/releases/download/Version-1-10-0/vigra-1.10.0-src-with-docu.tar.gz'
  sha1 '0a882bc09f5a6ec1f8381ff571020259eb88ee67'
  head 'https://github.com/ukoethe/vigra.git'

  depends_on :python => ['numpy', :optional]
  depends_on 'cmake' => :build
  depends_on 'jpeg'
  depends_on :libpng
  depends_on 'libtiff'
  depends_on 'hdf5' => :recommended
  depends_on 'fftw' => :recommended
  depends_on 'openexr' => :optional

  option 'without-check', 'skip tests'

  def install
    cmake_args = std_cmake_args
    cmake_args << '-DWITH_VIGRANUMPY=0' if build.without? :python
    cmake_args << '-DWITH_HDF5=0' if build.without? 'hdf5'
    cmake_args << '-DWITH_OPENEXR=1' if build.with? 'openexr'
    mkdir 'build' do
      system 'cmake', '..', *cmake_args
      system 'make'
      system 'make', 'check' if build.with? 'check'
      system 'make', 'install'
    end
  end
end
