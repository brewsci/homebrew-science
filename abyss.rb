class Abyss < Formula
  desc "ABySS: genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.0.2/abyss-2.0.2.tar.gz"
  sha256 "d87b76edeac3a6fb48f24a1d63f243d8278a324c9a5eb29027b640f7089422df"
  # doi "10.1101/gr.089532.108"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "7025ff7c66231c4569f7e2b863e5d346318e53f936444214b556823d8aea9eda" => :el_capitan
    sha256 "4660de95d48904e58162d5f765f0b0a172ce6a191165896d3496f31e079bd2a1" => :yosemite
    sha256 "ea81e7e419816a52320f2310918dece9611853f325cac305185ede106e6d5982" => :mavericks
    sha256 "fb19ca14831be318351900b9def2bee2c7c4196319ae9661ed7b8dd8ad4aa506" => :x86_64_linux
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
