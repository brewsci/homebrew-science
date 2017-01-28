class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "http://ccb.jhu.edu/software/stringtie"
  url "http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.2b.tar.gz"
  sha256 "12202e91bf8e314a59bca4b353eeb212e7e6926ea12a9ffdaedb8ee4818b5465"
  head "https://github.com/gpertea/stringtie.git"

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "984b5e6cf01b0a7dc02fd517ce6e4eefecc0422e4109ce13fd206db6adbb1ca7" => :sierra
    sha256 "626e41b97813e1fb2501175c3766c2d51a09008171a7b992a7711c160f634228" => :el_capitan
    sha256 "61f05ee8246d49d45e9f8a95f92aa3904d6ce01d2de5c7c0f0817920426b3340" => :yosemite
    sha256 "a3aa8520e257a27c70b9a8ef0c0260c9c7c97a0aa8ec4b97beee74249d885b5d" => :x86_64_linux
  end

  def install
    system "make", "release"
    bin.install "stringtie"
    doc.install "README", "LICENSE"
  end

  test do
    assert_match "transcripts", shell_output("#{bin}/stringtie 2>&1", 1)
  end
end
