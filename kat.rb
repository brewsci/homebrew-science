class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/releases/download/Release-2.3.2/kat-2.3.2.tar.gz"
  sha256 "5874ce68d13dc7af3d8de71281230e936b452cef8aaedb4c0312fe97ebd24e6f"
  # tag "bioinformatics"

  bottle do
    sha256 "e4e71ec5c25cdce5485125f0cc250ea70b0b3c919c65137094aac2b1ecc1524d" => :sierra
    sha256 "7021ffc35cf101a0f59f7a038761ed3fd519f76ffade8fb5ee68691f8d94a048" => :el_capitan
    sha256 "ed765c79b89a0b392ff368a82b6807a03945c8d76d2245f6556036fbcf6f94bc" => :yosemite
    sha256 "69161ef955046e0b80ab02ff0ff0dc04b69676c52274da94dcb2d9126a1a1a27" => :x86_64_linux
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
