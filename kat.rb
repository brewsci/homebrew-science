class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.3.2/kat-2.3.2.tar.gz"
  sha256 "5874ce68d13dc7af3d8de71281230e936b452cef8aaedb4c0312fe97ebd24e6f"
  revision 1
  # tag "bioinformatics"

  bottle do
    sha256 "5439d3f4dfe8dae4c4912add11059d02796575cfc35c2b22d23acb0fe658780b" => :sierra
    sha256 "ae25efdf65eecbe14848eeef24341514ef6e1023e9e44164f08d67413c54b71c" => :el_capitan
    sha256 "739c8ba2c27b5cb31408a2e7dae910bf62e7ac5471379632c18c5d48df7874b3" => :yosemite
    sha256 "83c810643bf0e084e993e0d176dc22c85135c936142c0f3dd73cf7152bff6570" => :x86_64_linux
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
  depends_on "boost"
  depends_on "gnuplot"

  if OS.linux?
    depends_on "matplotlib" => :python
    depends_on "numpy" => :python
    depends_on "scipy" => :python
  else
    depends_on :python3
    depends_on "matplotlib" => "with-python3"
    depends_on "numpy" => "with-python3"
    depends_on "scipy" => "with-python3"
  end

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
