class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.17.tar.gz"
  sha256 "3d5b221f7ec2de0eec5564c9aa45f17cd483c52b6977d22720bb3578c1d7e990"

  bottle do
    cellar :any_skip_relocation
    sha256 "e433e71d12831d56e68220397e771418f597208141df7190dfd468df20014dcd" => :el_capitan
    sha256 "dcf60340842ab8b5699f383453d6ad0aa4824fe179f73b570fb0817065b72718" => :yosemite
    sha256 "923afaff8450e1f11568e6b1b4adce00d1afb7d0ee33f254cef1f68cad171b60" => :mavericks
    sha256 "0d62931021a895a66fc63fc55658a31e5db6dcdacd057fd62a1c0bec4065774c" => :x86_64_linux
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
