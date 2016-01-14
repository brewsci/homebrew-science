class Cgns < Formula
  homepage "http://cgns.sourceforge.net"
  url "https://downloads.sourceforge.net/project/cgns/cgnslib_3.2/cgnslib_3.2.1.tar.gz"
  sha256 "34306316f04dbf6484343a4bc611b3bf912ac7dbc3c13b581defdaebbf6c1fc3"
  revision 2

  bottle do
    sha256 "8fada8f4255f962352708ea3a45a4917be1621ca17d3b8b77dd1da7b9898284e" => :el_capitan
    sha256 "aa0a9fbf3431e80a0a847f99a5f0a8d9e38f788d2fb64a196b89991b56b1db6c" => :yosemite
    sha256 "f95ca1093fc37645a2ada3911ce18cbe30ed2d57076b14c601479949dea24fe1" => :mavericks
  end

  depends_on :fortran
  depends_on "cmake" => :build
  depends_on "hdf5" => :recommended
  depends_on "szip"

  def install
    args = std_cmake_args + [
      "-DENABLE_FORTRAN=YES",
      "-DHDF5_NEED_SZIP=YES",
      "-DENABLE_TESTS=YES",
    ]

    args << "-DENABLE_64BIT=ON" if Hardware.is_64_bit? && MacOS.version >= :snow_leopard

    if build.with? "hdf5"
      args << "-DENABLE_HDF5=YES"
      args << "-DHDF5_NEED_ZLIB=YES"
      args << "-DCMAKE_SHARED_LINKER_FLAGS=-lhdf5"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "ctest --output-on-failure"
      system "make", "install"
    end
  end
end
