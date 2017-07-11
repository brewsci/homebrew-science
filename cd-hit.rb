class CdHit < Formula
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "http://cd-hit.org"
  # doi "10.1093/bioinformatics/btl158"
  # tag "bioinformatics"

  url "https://github.com/weizhongli/cdhit/releases/download/V4.6.8/cd-hit-v4.6.8-2017-0621-source.tar.gz"
  version "4.6.8"
  sha256 "b67ef2b3a9ff0ee6c27b1ce33617e1bfc7981c1034ea53f8923d025144e595ac"

  head "https://github.com/weizhongli/cdhit.git"

  # error: 'omp.h' file not found
  needs :openmp

  bottle do
    cellar :any
    sha256 "f501ff1231e6b965ad7473c552e05250b6b31750af75ff7deff4bda2fa520fe5" => :sierra
    sha256 "ae82eaccbc10d222d2098f08999ce7c9ba06a4847b8c9fce66f2c97cb1592a54" => :el_capitan
    sha256 "6eba5930225a89cf6e02766b921f8011ac88b14c0f582d26335c2075def4b3c0" => :yosemite
    sha256 "19949dfd655856415a3adbd4d1a70f7d3a1c9f415bad56812f5dd02507262960" => :x86_64_linux
  end

  def install
    args = (ENV.compiler == :clang) ? [] : ["openmp=yes"]

    system "make", *args
    bin.mkpath
    system "make", "PREFIX=#{bin}", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/cd-hit -h", 1)
  end
end
