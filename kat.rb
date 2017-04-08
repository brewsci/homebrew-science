class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.3.3/kat-2.3.3.tar.gz"
  sha256 "e15c2039cb7ebd77a0af440c6fca9a4e6f3b78c8c541ab9abc91928ba345c630"
  # tag "bioinformatics"

  bottle do
    sha256 "14b1cb9b07536502e7a61dde5f55bfcb54d20986f037b6e7df9f3f9a75423592" => :sierra
    sha256 "fa3132ddf9ba1d79e9742c0d12f5f2c1d705db5248bee77ee07050cfab563a5c" => :el_capitan
    sha256 "4a0aab934c0abd3dc3f151f6207c6004a74e7a509ef41128368645b51eec2f81" => :yosemite
    sha256 "6980368d07c0712ba64810405243e577d0b34444500830c8839a6b0da83e62ef" => :x86_64_linux
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
