class CdHit < Formula
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "http://cd-hit.org"
  # doi "10.1093/bioinformatics/btl158"
  # tag "bioinformatics"

  url "https://github.com/weizhongli/cdhit/releases/download/V4.6.6/cd-hit-v4.6.6-2016-0711.tar.gz"
  version "4.6.6"
  sha256 "97946f8ae62c3efa20ad4c527b8ea22200cf1b75c9941fb14de2bdaf1d6910f1"

  head "https://github.com/weizhongli/cdhit.git"

  # error: 'omp.h' file not found
  needs :openmp

  bottle do
    cellar :any
    sha256 "3fb261d867d15de894911baa06140b920b34408a5917b92a4aeb780db2402e78" => :el_capitan
    sha256 "44f2addb6cc0678b85a5c760ac9e83f9372c21a496e5ecea9b367e585c28aa5c" => :yosemite
    sha256 "c2750c16922bea6bd9df9120dd3bdb776c88f7f753eb01f938fd9ce8dfc987d3" => :mavericks
    sha256 "1d9d89d4c12a618f10263df837e3b77653e2684fd45984f3caba1104832d5779" => :x86_64_linux
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
