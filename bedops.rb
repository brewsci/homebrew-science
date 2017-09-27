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
    sha256 "f8fdada0472ebcbbca914025750e3d564fc4f1d1cfcc91ef0752a1674f1fea56" => :high_sierra
    sha256 "b0d92183777dd5cb72e5b8f3b06009c257bbb08bda354031218a1da9b0ac6c70" => :sierra
    sha256 "7d33abc10db89805a5864eb79a52565974659bf613193c85301c404e5f343f36" => :el_capitan
    sha256 "a60363875a13586fe666099031706b71b09a3fcf0c4a6aabff29841321d3be3c" => :x86_64_linux
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
