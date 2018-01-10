class Elph < Formula
  desc "Gibbs sampler for finding motifs in DNA or protein sequences"
  homepage "http://cbcb.umd.edu/software/ELPH/"
  url "ftp://ftp.cbcb.umd.edu/pub/software/elph/ELPH-1.0.1.tar.gz"
  sha256 "6d944401d2457d75815a34dbb5780f05df569eb1edfd00909b33c4c4c4ff40b9"

  bottle do
    cellar :any
    sha256 "ac6af3117b4b0c3c3c0c6272f4f5aea4874aac68c7d935f850f8ad0ca9ed44e0" => :sierra
    sha256 "343fd4dd9ab61ef4bb3f5c311e7ec05f4aca9b8d2ef1506375e0f2263a597274" => :el_capitan
    sha256 "7f08bf6c015398f52e032d2270805607731f42015ad1630f556e6a3699b04b9a" => :yosemite
  end

  fails_with :clang do
    cause "error: '-I-' not supported, please use -iquote instead"
  end

  def install
    cd "sources" do
      system "make"
      bin.install "elph"
    end
  end

  test do
    system "#{bin}/elph -h 2>&1 | grep elph"
  end
end
