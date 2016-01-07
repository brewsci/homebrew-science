class Methpipe < Formula
  homepage "http://smithlabresearch.org/software/methpipe/"
  url "http://smithlabresearch.org/downloads/methpipe-3.4.2.tar.bz2"
  sha256 "9dab70723f71af815a058d38abc963dcb43b2e25968e12dbcf17413512ededf7"
  head "https://github.com/smithlabcode/methpipe.git"

  depends_on "gsl"

  def install
    system "make", "all"
    system "make", "install"
    prefix.install "bin"
  end

  test do
    system "#{bin}/symmetric-cpgs", "-about"
  end
end
