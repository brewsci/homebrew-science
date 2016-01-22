class Bedops < Formula
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.15.tar.gz"
  sha256 "8364b319831936951835369ef582ac7ddbd15c29682ae0e45a80c4e6a8f36245"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any
    sha256 "ac1a745078141fc3c14950ba1bd27b15cc886ac5290942f03572d8f76b127a8a" => :yosemite
    sha256 "24f16e72a7f1401a67e50c851bcc02ea1d694fc08092331ebc611010acc24085" => :mavericks
    sha256 "c4c3d988b952f794b2bd41c7d9be8ec13ea27549c26d60a50611ed97ad0825bb" => :mountain_lion
  end

  env :std

  fails_with :gcc do
    build 5666
    cause "BEDOPS toolkit requires a C++11 compliant compiler"
  end

  def install
    ENV.O3
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")
    system "make"
    system "make", "install"
    bin.install Dir["bin/*"]
    doc.install %w[LICENSE README.md]
  end

  test do
    system "#{bin}/bedops", "--version"
  end
end
