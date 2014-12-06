require "formula"

class Emboss < Formula
  homepage "http://emboss.sourceforge.net/"
  url "ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.6.0.tar.gz"
  mirror "ftp://ftp.ebi.ac.uk/pub/software/unix/EMBOSS/EMBOSS-6.6.0.tar.gz"
  mirror "https://science-annex.org/pub/emboss/EMBOSS-6.6.0.tar.gz"
  sha1 "93749ebd0a777efd3749974d2401c3a2a013a3fe"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "cd15996f4eee38f64226a8293c55bce46f02774b" => :yosemite
    sha1 "7e2fb841a987b596f436ae3dd1354b48c7c0e425" => :mavericks
    sha1 "286d090099f6bed5e63f29a5b69e6f3340adaeff" => :mountain_lion
  end

  option "with-embossupdate", "Run embossupdate after `make install`"

  depends_on "pkg-config" => :build
  depends_on "libharu"    => :optional
  depends_on "gd"         => :optional
  depends_on "libpng"     => :recommended
  depends_on :x11         => :recommended
  depends_on :postgresql  => :optional
  depends_on :mysql       => :optional

  def install
    inreplace "Makefile.in", "$(bindir)/embossupdate", "" if build.without? "embossupdate"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --docdir=#{doc}
      --enable-64
      --with-thread
    ]
    args << "--without-x" if build.without? "x11"
    args << "--with-mysql" if build.with? "mysql"
    args << "--with-postgresql" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
  end
end
