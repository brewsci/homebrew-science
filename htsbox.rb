class Htsbox < Formula
  desc "Experimental tools on top of htslib"
  homepage "https://github.com/lh3/htsbox"
  # tag "bioinformatics"

  url "https://github.com/lh3/htsbox/archive/r312.tar.gz"
  version "r312"
  sha256 "18956deaf1d163a01f36e7849aba8ff01e9d883bd4792f870debdce53d0b665e"

  head "https://github.com/lh3/htsbox.git", :branch => "lite"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "6b6854f17dc317c0acc072dfa558dce9b23ed42f47a04eae3ddff3f632c1adf3" => :el_capitan
    sha256 "f8ab629404d62b23036df97ab805ddbacacae8d444153b6928a8ea66c125391a" => :yosemite
    sha256 "fe2624546e9009cc83769ee41fe0834d37b95374b8f915b3478a3ed8cd6afe7c" => :mavericks
  end

  depends_on "htslib"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "htsbox"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/htsbox 2>&1", 1)
  end
end
