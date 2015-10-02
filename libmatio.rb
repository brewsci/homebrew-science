require 'formula'

class Libmatio < Formula
  homepage 'http://matio.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/matio/matio/1.5.2/matio-1.5.2.tar.gz'
  sha1 'd5a83a51eb2550d75811d2dde967ef3e167d4f52'
  revision 1

  bottle do
    cellar :any
    sha256 "fc4f887587a4faf0efa6093e0c38cd172b8a9f3bb44e062d166ebdb34c44335c" => :el_capitan
    sha256 "92c4859f40adb08e7f98766a55c25daf5b4bffc000c9aa51ede93c2b46ac39c2" => :yosemite
    sha256 "ed278812215d9647a7451de2694995f6f028f27197223d195a677f1136c6d4f4" => :mavericks
  end

  option :universal
  option 'with-hdf5', 'Enable support for newer MAT files that use the HDF5-format'

  depends_on 'hdf5' => :optional

  def install
    ENV.universal_binary if build.universal?
    args = %W[
      --prefix=#{prefix}
      --with-zlib=/usr
      --enable-extended-sparse=yes
    ]

    if build.with? 'hdf5'
      args << "--with-hdf5=#{HOMEBREW_PREFIX}" << "--enable-mat73=yes"
    else
      args << "--with-hdf5=no"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end
end
