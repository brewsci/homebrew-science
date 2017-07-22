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
    sha256 "3d2bc31f44914cfcac0ef0d5467ab9dd04360edc13f50dd9079443004709ad4c" => :sierra
    sha256 "783b05a7d0798ce8885b65416b0d5bca166fc6859fb11fa4de54478a33cae752" => :el_capitan
    sha256 "ea60bd5ff076dd6f5a64d33398a7fc496e2a0e8602306250974bccc4e2162935" => :yosemite
    sha256 "adcbca63b03c170eb178fe557f34df3597adafef3a4e9f547856c2edfe600619" => :x86_64_linux
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
