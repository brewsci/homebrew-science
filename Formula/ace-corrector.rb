class AceCorrector < Formula
  desc "Correct substitution errors in Illumina reads"
  homepage "https://github.com/Sheikhizadeh/ACE"
  # doi "10.1093/bioinformatics/btv332"
  # tag "bioinformatics"

  url "https://github.com/Sheikhizadeh/ACE.git",
    revision: "189f154997aeef954d690a8a08300233c21305f3"
  version "20150501"

  head "https://github.com/Sheikhizadeh/ACE.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, yosemite:      "b2c892395c18bcc13554e31a6ed081a452ca200248969624e88e6dcd81c3fc18"
    sha256 cellar: :any, mavericks:     "fc42d8edbc95c265d8a07d66768a769877fb1f14ebafd2e9217cbcb1b4230ee7"
    sha256 cellar: :any, mountain_lion: "4d3ecdea8c3226b4c9bb2e438fa3020f0e5e3836d47b17d6111fa8096a894681"
    sha256 cellar: :any, x86_64_linux:  "2a7d5e89f16e4fd0cbfce19ed4f487cb1d288b9026827ef4bfe37d36dc1af703"
  end

  needs :openmp

  def install
    system "make"
    bin.install "ace"
  end

  test do
    assert_match "Genome_length", shell_output("ace 2>&1")
  end
end
