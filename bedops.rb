class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.30.tar.gz"
  sha256 "218e0e367aa79747b2f90341d640776eea17befc0fdc35b0cec3c6184098d462"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cf8e25faa68036c3d506c6a015e32778ff614243e37047f9e8a092208468be8" => :high_sierra
    sha256 "406d72ffe4fdc82d3e001ed77f983b54d227a4dcc1a0c97afde3f6162afdac74" => :sierra
    sha256 "84bcd1137aae15c1f7143dcb548c1b23f7f6c3ad8757097798dc6ad7946b4360" => :el_capitan
    sha256 "e02d979f82d01db8efdac8a46cc7acb5b79bc198adfabd81f5664a42b5799f68" => :x86_64_linux
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
