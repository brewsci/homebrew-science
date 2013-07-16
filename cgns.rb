require 'formula'

class Cgns < Formula
  homepage 'http://cgns.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/cgns/cgnslib_3.1/cgnslib_3.1.3-4.tar.gz'
  version '3.1.3.4'  # Release d of version a.b.c (we add the release to the version)
  sha1 '148396af2b9f6b6b273561cf4e474e667adc7508'

  depends_on :fortran
  depends_on 'cmake' => :build
  depends_on 'hdf5'

  def install
    args = std_cmake_args + [
      '-DENABLE_FORTRAN=YES',
      '-DENABLE_HDF5=YES',
      '-DHDF5_NEED_ZIP=YES',
      '-DCMAKE_SHARED_LINKER_FLAGS=-lhdf5'
    ]

    args << '-DENABLE64_BIT' if Hardware.is_64_bit? and MacOS.version >= 10.6

    mkdir 'build' do
      system 'cmake', '..', *args
      system 'make install'
    end
  end
end
