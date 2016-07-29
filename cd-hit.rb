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
    sha256 "d39f86e1115c63cbfb0f69ac9f10112ba93cde7de8e5113b8c62ab59bd770557" => :el_capitan
    sha256 "687cb4899593b076dad1c9b7f82134b0e348db6a27dfa53b2743ae67ada0e71b" => :yosemite
    sha256 "c4140245c4490436da64e35f3dc92e08903df12516e3b949acd013293ecbea4f" => :mavericks
    sha256 "993fcce46c3a591e8ddd6453fd53f0b0c43f46a69099b68c0976b3aa843687ca" => :x86_64_linux
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
