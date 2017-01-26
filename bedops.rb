class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.22.tar.gz"
  sha256 "439a9136a08501da9d1d887ab7e24daf3d954a5b1d00a1317ab11e2c7322a51b"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f5eecdff1dfe87183591e7779757cb4197844e15ddcd3258ae3d2d345cf67bb" => :sierra
    sha256 "91210cc1ef59967ac7b40df52cc70604a489c0a3ddf51bed3255e934dc39ba95" => :el_capitan
    sha256 "fabfadbc8612ae9403f72ed53fb22bd62368f836de44f045ab0e8c32add44fe3" => :yosemite
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
