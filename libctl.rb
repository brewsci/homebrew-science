class Libctl < Formula
  homepage "http://ab-initio.mit.edu/wiki/index.php/Libctl"
  url "http://ab-initio.mit.edu/libctl/libctl-3.2.2.tar.gz"
  sha256 "8abd8b58bc60e84e16d25b56f71020e0cb24d75b28bc5db86d50028197c7efbc"

  bottle do
    cellar :any_skip_relocation
    sha256 "08bc925eac1ce0b3dd4df2f7ee36135cd3cb1307b0e306663fd62183f52854f0" => :sierra
    sha256 "45c54a72e32d20be848af61843b1d0e7b76172b0f1d5bb33238527a731a3e897" => :el_capitan
    sha256 "f40890ef37a3be69fbbf99e94616225b5bf09f43e110c9481e7d2156395658e4" => :yosemite
  end

  depends_on "guile"
  depends_on :fortran

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "LIBS=-lm"
    system "make", "install"
  end
end
