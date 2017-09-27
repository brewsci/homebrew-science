class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.29.tar.gz"
  sha256 "a7d41a243a54d03bbb63305811b5d27f37bafda2203a7c7f311a773aeabe5028"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31d095b6319be328419d5aa1dbc9ef9274effdf979026777e662a678d802a392" => :sierra
    sha256 "bd15193ba04f236d1c49ee83267738d9908ece09c8192d5a4a4c4c52bfddac51" => :el_capitan
    sha256 "f5ac07bb625b9a3b1b5ba56efa013a01180f1d2ad8935f3066dd7098582f4174" => :yosemite
    sha256 "a4f07ff6d1251a98a1ad21910df259cd385aeab89171e07556714de14c276aa9" => :x86_64_linux
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
