class Abyss < Formula
  desc "ABySS: genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.0.2/abyss-2.0.2.tar.gz"
  sha256 "d87b76edeac3a6fb48f24a1d63f243d8278a324c9a5eb29027b640f7089422df"
  # doi "10.1101/gr.089532.108"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "251f9ae9ceae20c2320ca368043ce36f8fce74fd86efcbdc1a61ad5182c9cdfc" => :sierra
    sha256 "240ba4e0961f45c54084e14b5f3f6aaf09864539e605d3c641dc1164c078feea" => :el_capitan
    sha256 "991ef66e31957509517bcd373476753b5a314ff2b657f02260bcea1314da09cf" => :yosemite
    sha256 "31da03dd3dabc22c36c0ef9cb748d08e669e49fc3f29a4f64b0939d6be8354ca" => :x86_64_linux
  end

  head do
    url "https://github.com/bcgsc/abyss.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  option :cxx11
  option "with-maxk=", "Set the maximum k-mer length to N [default is 128]"
  option "without-test", "Skip build-time tests (not recommended)"
  option "with-openmp", "Enable OpenMP multithreading"

  deprecated_option "enable-maxk" => "with-maxk"
  deprecated_option "without-check" => "without-test"

  needs :openmp if build.with? "openmp"

  # Only header files are used from these packages, so :build is appropriate
  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on :mpi => [:cc, :recommended]

  # strip breaks the ability to read compressed files.
  skip_clean "bin"

  def install
    ENV.cxx11 if build.cxx11?
    system "./autogen.sh" if build.head?

    args = [
      "--enable-maxk=#{ARGV.value("with-maxk") || 128}",
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
    ]

    system "./configure", *args
    system "make"
    # make check currently fails due to an upstream bug.
    # See https://github.com/bcgsc/abyss/issues/133
    # system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/ABYSS", "--version"
  end
end
