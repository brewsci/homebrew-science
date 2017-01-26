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
    sha256 "2ce3e942c119118bc12feb0e5f15a60bd2bca9fcc5c3f604bbaa35f7f3755647" => :el_capitan
    sha256 "084b521cd3999f89e586d36493b14e5eb8678a0c9058a98814472becfc7f2064" => :yosemite
    sha256 "f6097d30f3a5e1e4c51928a5406b4838aa48c1e7f172390afa32b2a7daa55777" => :mavericks
    sha256 "b2ac4d2f11b5bfc4889381022b82af9ae1561740ac1e557670e7217672b4cdee" => :x86_64_linux
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
