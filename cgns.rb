require 'formula'

class Cgns < Formula
  homepage 'http://cgns.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/cgns/cgnslib_3.2/cgnslib_3.2.1.tar.gz'
  sha1 'ac8e4d226da9397d79385c19a7cea82b4abc1983'

  depends_on :fortran
  depends_on 'cmake' => :build
  depends_on 'hdf5' => :recommended
  depends_on 'szip'

  def install
    args = std_cmake_args + [
      '-DENABLE_FORTRAN=YES',
      '-DHDF5_NEED_SZIP=YES',
      '-DENABLE_TESTS=YES'
    ]

    args << '-DENABLE_64BIT=ON' if Hardware.is_64_bit? and MacOS.version >= :snow_leopard

    if build.with? 'hdf5'
      args << '-DENABLE_HDF5=YES'
      args << '-DHDF5_NEED_ZLIB=YES'
      args << '-DCMAKE_SHARED_LINKER_FLAGS=-lhdf5'
    end

    mkdir 'build' do
      system 'cmake', '..', *args
      system 'make'
      system 'ctest --output-on-failure'
      system 'make install'
    end
  end
end
