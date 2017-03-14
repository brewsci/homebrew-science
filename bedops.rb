class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.26.tar.gz"
  sha256 "9b8ff43beec7b6e327179477b800a9c7ce98a010bbf59ba41fc2d7da9869586d"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba4f2d77c3e1d8e1fb1a1916f579de3f3ace667fca60f7377d50180060a1aa9b" => :sierra
    sha256 "20ac9e1970128d64907680d0db0a55d4ffb67dc66d51d52e73b326364be7bbca" => :el_capitan
    sha256 "b345531c329ab1db042e4908b25f2d23ad66e67815c4adc22c0537ebd9804467" => :yosemite
    sha256 "ae088089a4ebcdd2eb3582cbe2926dcdb7870ca05a32f7e80dc44ea7920a38f7" => :x86_64_linux
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
