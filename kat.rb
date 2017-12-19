class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.3.4/kat-2.3.4.tar.gz"
  sha256 "40ac5e1ea310b4dac35620f74e489a749c355b41d850d297a06c3822f58295e1"
  revision 2
  # tag "bioinformatics"

  bottle :disable, "needs to be rebuilt with latest boost"

  head do
    url "https://github.com/TGAC/KAT.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-docs", "Build documentation"

  needs :cxx11

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on :python unless OS.mac?
  depends_on :python3
  depends_on "boost"
  depends_on "gnuplot"
  depends_on "matplotlib"
  depends_on "numpy"
  depends_on "scipy"

  def install
    ENV.cxx11
    ENV["PYTHON_EXTRA_LDFLAGS"] = "-undefined dynamic_lookup"

    system "./autogen.sh" if build.head?

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-boost=#{Formula["boost"].opt_prefix}"

    if build.with? "docs"
      system "make", "man"
      system "make", "html"
    end
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kat --version")
  end
end
