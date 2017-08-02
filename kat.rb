class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.3.4/kat-2.3.4.tar.gz"
  sha256 "40ac5e1ea310b4dac35620f74e489a749c355b41d850d297a06c3822f58295e1"
  # tag "bioinformatics"

  bottle do
    sha256 "deb09b42ee6918c5d085ce5a71128907cc66590a525edc7683ddbf3a81a9ca58" => :sierra
    sha256 "fcf3aa5a7a062d651fd2d5917e245c03605f79fca6fc500451ec1ca004efaa97" => :el_capitan
    sha256 "3fde5dfe54fd12fe189ff7bc593a4c8a9100119efc5990f2d9df263b19323d27" => :yosemite
    sha256 "50f16a555329882595778c5a54efbd2c8ce65f3d6f57498a25785c6c466975e4" => :x86_64_linux
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

  depends_on :python3
  depends_on "matplotlib" => "with-python3"
  depends_on "numpy" => "with-python3"
  depends_on "scipy" => "with-python3"

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
