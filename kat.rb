class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.3.4/kat-2.3.4.tar.gz"
  sha256 "40ac5e1ea310b4dac35620f74e489a749c355b41d850d297a06c3822f58295e1"
  revision 1
  # tag "bioinformatics"

  bottle do
    sha256 "2ee4951cf052bb1b735e69e7c8e8daeb6ca8ec8b28bc1cd6b43f56700ac9f433" => :sierra
    sha256 "d44878f2e4a4e19c7dbff4af223bed7e74917892a9a8f03ef40540554cbbb2d2" => :el_capitan
    sha256 "ee74a2829a1702187eac36a74c457076278cbf93e710a06166186403a28dee4c" => :x86_64_linux
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
