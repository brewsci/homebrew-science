class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"
  revision 1

  url "https://github.com/bbuchfink/diamond/archive/v0.8.17.tar.gz"
  sha256 "3d5b221f7ec2de0eec5564c9aa45f17cd483c52b6977d22720bb3578c1d7e990"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb8cd2ccb7600911b3be215aee91189a69371809c8efee7b0541f883dc0fd0e2" => :el_capitan
    sha256 "f168f6561a456fb7ccd6815c0dae15e2f679f99f9de855ab32e6129e9cedebef" => :yosemite
    sha256 "46dd4a28bd8946e8763f0d584419529a857db173d9d2659a0194570a6b5f54bb" => :mavericks
    sha256 "addedc77add5094aea292285fa3f784804a587a608ed10a43c6759111d82fb20" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end
