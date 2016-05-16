class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.19.tar.gz"
  sha256 "f170e2187d4136ae764fedd731d117f9f1ad243ee39452098f221c79217a77e4"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b31e30e93d6988e13995ccdf597949629fc8d993d433dc73400654c27d5fe3f0" => :el_capitan
    sha256 "13fef35487fa299a6b1c7ab5c3f438606e953005f67e865a671308ca8a0aa490" => :yosemite
    sha256 "8ad8aa41592fd590ad5391789ee1761dd09c6301be4c908dad7f652dc54c1979" => :mavericks
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
