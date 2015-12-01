class Quip < Formula
  homepage "http://homes.cs.washington.edu/~dcjones/quip/"
  url "http://homes.cs.washington.edu/~dcjones/quip/quip-1.1.8.tar.gz"
  sha256 "525c697cc239a2f44ea493a3f17dda61ba40f83d7c583003673af9de44775a64"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "quip --version"
  end
end
