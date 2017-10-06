class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.3.4/kat-2.3.4.tar.gz"
  sha256 "40ac5e1ea310b4dac35620f74e489a749c355b41d850d297a06c3822f58295e1"
  revision 1
  # tag "bioinformatics"

  bottle do
    rebuild 1
    sha256 "a9c66de5857be1d9d3d9dac7aac4a27a7af0b29cda2d5c4982a56ad6f7b2b50c" => :sierra
    sha256 "e0de040c7819c2930a3817fae93cacbd4342fe3e2817aa57d3dcd16074a26fd1" => :el_capitan
    sha256 "e3495ebaefacec640febae7bdd23febae627653cc4d8f40233b97b061932729b" => :yosemite
    sha256 "8759672c6f3b9eacc8fd73956b06389440dcc1a8da1b7a8e94b963e77ce96edb" => :x86_64_linux
  end

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
