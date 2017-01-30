class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.23.tar.gz"
  sha256 "61cf6895782f3184f1853f144357e0d1a45e8e42821853ba9562bed0f4509144"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f225ee1019389f966d3b849fecaa184817fca99ce85438a1df5fc2cfa72ef81" => :sierra
    sha256 "eb618a7116ad53158fb946898b58d9e27df63fdbeff2c5dd3ef4bfc874fd635c" => :el_capitan
    sha256 "22be7125298b89ddf330645d68202b79bea73ee2b21abeeff87d5ac36ee35811" => :yosemite
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
