class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.20.tar.gz"
  sha256 "1c604b1a85d9acdf444f497e3a24c16e5b60df57d8699b0a8594ff2d6188a41a"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b31e30e93d6988e13995ccdf597949629fc8d993d433dc73400654c27d5fe3f0" => :el_capitan
    sha256 "13fef35487fa299a6b1c7ab5c3f438606e953005f67e865a671308ca8a0aa490" => :yosemite
    sha256 "8ad8aa41592fd590ad5391789ee1761dd09c6301be4c908dad7f652dc54c1979" => :mavericks
    sha256 "db6bba518c862722756fb2544881a2dcbaabfd4580404ccc25ecba504930c9dc" => :x86_64_linux
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
