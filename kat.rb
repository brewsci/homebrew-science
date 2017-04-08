class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.3.3/kat-2.3.3.tar.gz"
  sha256 "e15c2039cb7ebd77a0af440c6fca9a4e6f3b78c8c541ab9abc91928ba345c630"
  # tag "bioinformatics"

  bottle do
    sha256 "0891a085c65f09354faf23641d98ff91a241364241c0de5b6715231f1343957f" => :sierra
    sha256 "29fda52b621aaef8e46b70aa1b6014943d1ce2dda8b37234ee183eff02128cde" => :el_capitan
    sha256 "8779698d17a29c7d22e715a68ea2b17d371388e08700b5c36c5fd0159d6f3071" => :yosemite
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
