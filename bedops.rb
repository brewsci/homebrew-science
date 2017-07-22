class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.27.tar.gz"
  sha256 "705b2837b8801333eaf9bb3b0538c51af240ee16544f5bc6aa30c580eb293963"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56abd732c581a0df4d7d7d6a77a750d7854faf7d33e2f094366168b90b889045" => :sierra
    sha256 "6407907c45ceac100d4b1f8602eeb5c04256da6457aabb7e5d07f6c9b0f232ab" => :el_capitan
    sha256 "f322516ade8f9cfc8cb1b34b6335ea2c3eafbe8161ee319499beb97b13df8d39" => :yosemite
    sha256 "4c149f523f7368a6fa3b2d5f8c218b0dd8878b9f7275aadaacbbc5a417ac606a" => :x86_64_linux
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
