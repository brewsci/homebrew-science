class CdHit < Formula
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "http://cd-hit.org"
  # doi "10.1093/bioinformatics/btl158"
  # tag "bioinformatics"

  url "https://github.com/weizhongli/cdhit/releases/download/V4.6.4/cd-hit-v4.6.4-2015-0603.tar.gz"
  version "4.6.4"
  sha256 "ca0050b6b27649dd548b6d74c2873dd76cff7bfdf70fb6f8e8578d0fa128d92c"

  head "https://github.com/weizhongli/cdhit.git"

  # error: 'omp.h' file not found
  needs :openmp

  bottle do
    cellar :any
    sha256 "d39f86e1115c63cbfb0f69ac9f10112ba93cde7de8e5113b8c62ab59bd770557" => :el_capitan
    sha256 "687cb4899593b076dad1c9b7f82134b0e348db6a27dfa53b2743ae67ada0e71b" => :yosemite
    sha256 "c4140245c4490436da64e35f3dc92e08903df12516e3b949acd013293ecbea4f" => :mavericks
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
