class Methpipe < Formula
  homepage "http://smithlabresearch.org/software/methpipe/"
  url "http://smithlabresearch.org/downloads/methpipe-3.4.3.tar.bz2"
  sha256 "56716370211a7b45b0a3a2994afb64d64c15dd362028f9ecd8a0551a6e6d65c3"
  revision 1
  head "https://github.com/smithlabcode/methpipe.git"
  # tag "bioinformatics"

  bottle :disable, "Missing library: libgsl.19.dylib"

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
