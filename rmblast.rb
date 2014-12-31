class Rmblast < Formula
  homepage "http://www.repeatmasker.org/RMBlast.html"
  #tag "bioinformatics"

  version "2.2.28"
  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "7bbdd22297a0c56ba26f9a0a3df04119736fd232" => :yosemite
    sha1 "e440f190b9a9ff114011dd82b4760874540077e4" => :mavericks
    sha1 "119dc8638ea52180b18e8c5e607bae25d59aeb1e" => :mountain_lion
  end

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
    system "#{bin}/rmblastn", "-help"
  end
end
