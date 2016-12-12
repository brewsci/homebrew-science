class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.3.1/kat-2.3.1.tar.gz"
  sha256 "50db7afedf285612bb30852fb7b9465b26b356e3adf4fc82fceb788c0520a65d"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "5978032303b587966edf2b86340039148df15681137a9da0d0958089d86bf81b" => :el_capitan
    sha256 "1d5c0781c5f127c2a5e00a903b26ab0e7c58877a41290c70f2960554b9acf49a" => :yosemite
    sha256 "0d5f2252b25b92a9443349633098c5405cd1e4d6413e6eeb79b393e61d56ccf8" => :mavericks
    sha256 "bebc195a4bae51ca61606997d493924863455380068e4bd8145a5f06d067dff1" => :x86_64_linux
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
