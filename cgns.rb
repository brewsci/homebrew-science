require 'formula'

class Cgns < Formula
  homepage 'http://cgns.sourceforge.net'
  url 'http://sourceforge.net/projects/cgns/files/cgnslib_3.1/cgnslib_3.1.4-2.tar.gz'
  version '3.1.4.2'
  sha1 '26c16ce5d01264aab208a588b636f1de6de4bb1f'

  depends_on :fortran
  depends_on 'cmake' => :build
  depends_on 'hdf5'
  depends_on 'szip'

  def install
    args = std_cmake_args + [
      '-DENABLE_FORTRAN=YES',
      '-DENABLE_HDF5=YES',
      '-DHDF5_NEED_SZIP=YES',
      '-DHDF5_NEED_ZLIB=YES',
      '-DCMAKE_SHARED_LINKER_FLAGS=-lhdf5',
      '-DENABLE_TESTS=YES'
    ]

    args << '-DENABLE_64BIT=ON' if Hardware.is_64_bit? and MacOS.version >= :snow_leopard

    mkdir 'build' do
      system 'cmake', '..', *args
      system 'make'
      system 'ctest --output-on-failure'
      system 'make install'
    end
  end

end
