class Edirect < Formula
  desc "Access NCBI's databases from the shell"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/6.00.20170109/edirect.tar.gz"
  sha256 "b0709d89394ceee1c97bfc44c993ce074181837f79def2c6958edc3e5ffa7d29"
  head "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/current/edirect.tar.gz"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "3020ac2326c9f560cf62d6e29522d3d1fa8648f938535181f0eea3a751430d05" => :sierra
    sha256 "3cb6223205802f84ab23e7ded9c275c2aa3f5e4a0a6ad63fa55fa3c2f599baec" => :el_capitan
    sha256 "3cb6223205802f84ab23e7ded9c275c2aa3f5e4a0a6ad63fa55fa3c2f599baec" => :yosemite
    sha256 "f908f5575cb894c3fa0ea2a7d2279dcdcc43ca709c5d85a7912a1076786d2f11" => :x86_64_linux
  end

  depends_on "HTML::Entities" => :perl
  depends_on "LWP::Simple" => :perl
  depends_on "LWP::Protocol::https" => :perl

  def install
    doc.install "README"
    libexec.install "setup.sh", "setup-deps.pl"
    rm ["Mozilla-CA.tar.gz", "xtract.go"]
    bin.install Dir["*"]
  end

  test do
    system bin/"esearch", "-version"
  end
end
