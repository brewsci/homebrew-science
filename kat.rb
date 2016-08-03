class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.1.1/kat-2.1.1.tar.gz"
  sha256 "bcb86a01bdd2aa01cc64c6d2f2a33fff1a71961867e45a21de8de303e6f3440d"
  # tag "bioinformatics"
  revision 1

  bottle do
    cellar :any
    sha256 "668b031af5125dd68f69175c3d46808e82d70334f2e187b0f84b034e6f988d11" => :el_capitan
    sha256 "76b37eb9758cd693baebe92e521fa3c8311df3915e2f2ca5de8f228cce629b6f" => :yosemite
    sha256 "ce0c9790770b5c667b9695fb12475eab906de0f5d99f91689bc960b6bf4cb438" => :mavericks
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
