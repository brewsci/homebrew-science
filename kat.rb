class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.1.0/kat-2.1.0.tar.gz"
  sha256 "29a44367e335f56d7ef1c80dfeb58e3d4fa07705ef36116013ec83ad0fb80864"
  # tag "bioinformatics"

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
