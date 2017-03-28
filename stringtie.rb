class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://ccb.jhu.edu/software/stringtie"
  url "https://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.3b.tar.gz"
  sha256 "7fc6130029569083c36ad176919bc7d2a52b6436642a6276e665cb1d31cc0bfb"
  head "https://github.com/gpertea/stringtie.git"

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaa241550ade89bd37cc7a8a21409e7e66a2a9a40a32f9ebb0fd5cea4425d869" => :sierra
    sha256 "fc1ef473f4edcad51978fd679edd9141553a1a5c9778caa8e9c64afe046d8dec" => :el_capitan
    sha256 "42aae1a1cb44b15a11464f66cfa0f6c5ac40ea021b47366a90cd2d1bb304cefc" => :yosemite
    sha256 "77ea2eb90127e916a2c1f513052312fa27446d5caac0456418be587c1733ebcb" => :x86_64_linux
  end

  def install
    system "make", "release"
    bin.install "stringtie"
  end

  test do
    assert_match "transcripts", shell_output("#{bin}/stringtie 2>&1", 1)
  end
end
