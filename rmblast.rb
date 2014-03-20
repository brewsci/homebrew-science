require "formula"

class Rmblast < Formula
  homepage "http://www.repeatmasker.org/RMBlast.html"
  version "2.2.28"
  if OS.mac?
    url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/LATEST/ncbi-rmblastn-#{version}-universal-macosx.tar.gz"
    sha1 "a8f74b034d88c3e2202dd9a4dd30fdb78161aa75"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/LATEST/ncbi-rmblastn-#{version}-x64-linux.tar.gz"
    sha1 "02abee397973ccdf7d68e161203bd8dbe9322a6c"
  else
    raise "Unknown operating system"
  end

  depends_on "blast" => :recommended

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/rmblastn -help"
  end
end
