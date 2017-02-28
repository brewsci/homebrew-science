class Atpdec < Formula
  homepage "https://atpdec.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/atpdec/atpdec%20sources/1.7/atpdec-1.7.tar.gz"
  sha256 "6f9d80ddd0438aaa96e003ca46d1ff6f117d2d70ea2f34c28af57e968e9f98f7"

  depends_on "libsndfile"
  depends_on "libpng"

  def install
    system "make"
    bin.install "atpdec"
  end

  test do
    system "atpdec"
  end
end
