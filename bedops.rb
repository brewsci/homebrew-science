class Bedops < Formula
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.15.tar.gz"
  sha256 "8364b319831936951835369ef582ac7ddbd15c29682ae0e45a80c4e6a8f36245"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c5a2dfda0ea2658bc505ef5bdf47a199b810fe36f20a8fffe275395afc1cc80" => :el_capitan
    sha256 "5faad7689e3ced8019f9f9833f629f581237922753fa8ff3785f8e23c5f48eab" => :yosemite
    sha256 "18f3d8dbcd1bb202eb913c7238e5249dcf0ea98996306ecedbe090d2d56e5e91" => :mavericks
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
