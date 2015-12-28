class Rmblast < Formula
  homepage "http://www.repeatmasker.org/RMBlast.html"
  # tag "bioinformatics"

  version "2.2.28"
  bottle do
    cellar :any
    sha256 "5d9cf1a5413fd7c28c32652b846eb8b1ddf8bf6014dcd10ccf8c29df85b36231" => :yosemite
    sha256 "9b98e8e75a24c36c9dc2ecbd5db33953295b1b42a081faa5ae092e8b8b735356" => :mavericks
    sha256 "02dd45f7669741ef273f314eccc57ddd17a222beee934aea6cf3778dc0101f70" => :mountain_lion
  end

  if OS.mac?
    url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/LATEST/ncbi-rmblastn-#{version}-universal-macosx.tar.gz"
    sha256 "f94e91487b752eb24386c3571250a3394ec7a00e7a5370dd103f574c721b9c81"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/LATEST/ncbi-rmblastn-#{version}-x64-linux.tar.gz"
    sha256 "e6503ad25a6760d2d2931f17efec80ba879877b4042a1d10a60820ec21a61cfe"
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
