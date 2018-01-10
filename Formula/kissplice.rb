class KisspliceDownloadStrategy < CurlDownloadStrategy
  def curl(*args)
    args << "--disable-epsv"
    super
  end
end

class Kissplice < Formula
  desc "Local transcriptome assembler for SNPs, indels and AS events"
  homepage "http://kissplice.prabi.fr"
  url "ftp://pbil.univ-lyon1.fr/pub/logiciel/kissplice/download/kissplice-2.4.0-p1.tar.gz",
    :using => KisspliceDownloadStrategy
  sha256 "f4569b444cd0b10eba2a5c3f883d3fcbaf092201a9ebdc4d4c0030b4641676f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "11d2fc4398c44899d258555b391ccd75895b1c84e0f3204c8e07627b4e166f10" => :sierra
    sha256 "bad8602b1046b940e9a5fec2ceec34c4bab7c26bb7f17a157c6b1c040066dbdc" => :el_capitan
    sha256 "6ff193c28f3548b46aaf7a43b8ef91550e6ba74d4dd32052ac03175c0aea7f66" => :yosemite
    sha256 "62ee2d97906df8cdcedce4060130183264243e8a8835f4a25e8fe610d097be1a" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/kissplice", "--version"
  end
end
