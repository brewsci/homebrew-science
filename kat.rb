class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.1.1/kat-2.1.1.tar.gz"
  sha256 "bcb86a01bdd2aa01cc64c6d2f2a33fff1a71961867e45a21de8de303e6f3440d"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "60baa4159c9639b83edac2c04907a639df2a9effb5169e6e326306f6430a7ff3" => :el_capitan
    sha256 "cdc42fece013f1609e9998c40c8ec7394e1bf584f1a9fde06111a965a77ec4a8" => :yosemite
    sha256 "97f2048097cdf6559651e629e4ea455f55d6d6fa7eb72f9deec99dfd572b4630" => :mavericks
  end

  head do
    url "https://github.com/TGAC/KAT.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-docs", "Build documentation"

  needs :cxx11

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gnuplot"
  depends_on "matplotlib" => :python
  depends_on "numpy" => :python
  depends_on "scipy" => :python
  depends_on "sphinx-doc" => :python if build.with? "docs"

  def install
    ENV.cxx11

    system "./autogen.sh" if build.head?

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"

    if build.with? "docs"
      system "make", "man"
      system "make", "html"
    end
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s,
                 shell_output("#{bin}/kat --version")
  end
end
