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
