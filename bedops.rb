class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.24.tar.gz"
  sha256 "071d6c418271e7e5d33f540d0091000c02d799d64ff57c79b87d92d64c7d8609"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5eed1895f5e0c5285a65ee375cd12ec504e49c43e2b43d7ae41a824dfe952cdb" => :sierra
    sha256 "2d7ed2603377ec748542c50dcd419f3ed131f35fe4a007c7fb148beb4ecb9891" => :el_capitan
    sha256 "a254a1d62033d0b5541ab61e0f54160c1da307908e3b0bf60596b9e64a11247b" => :yosemite
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
