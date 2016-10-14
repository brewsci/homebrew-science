class Elph < Formula
  desc "Gibbs sampler for finding motifs in DNA or protein sequences"
  homepage "http://cbcb.umd.edu/software/ELPH/"
  url "ftp://ftp.cbcb.umd.edu/pub/software/elph/ELPH-1.0.1.tar.gz"
  sha256 "6d944401d2457d75815a34dbb5780f05df569eb1edfd00909b33c4c4c4ff40b9"

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
