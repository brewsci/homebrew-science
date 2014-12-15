require 'formula'

class Cgns < Formula
  homepage 'http://cgns.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/cgns/cgnslib_3.2/cgnslib_3.2.1.tar.gz'
  sha1 'ac8e4d226da9397d79385c19a7cea82b4abc1983'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "04e46518aa5f34b9b948bf4e1eaf64faf7b8420d" => :yosemite
    sha1 "4ffd47664cdfc10aee4669f3360ec7ea424732ed" => :mavericks
    sha1 "273709639cfa759647d3001270992070f9820095" => :mountain_lion
  end

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
