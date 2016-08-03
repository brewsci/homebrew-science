class Abyss < Formula
  desc "ABySS: genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  # doi "10.1101/gr.089532.108"
  # tag "bioinformatics"

  url "https://github.com/bcgsc/abyss/releases/download/1.9.0/abyss-1.9.0.tar.gz"
  sha256 "1030fcea4bfae942789deefd3a4ffb30653143e02eb6a74c7e4087bb4bf18a14"
  revision 1

  bottle do
    cellar :any
    sha256 "f0df6ae35b0db758ecba42d60cf7f6bf793e9cfe54bf05e6663afc51f4cbb5eb" => :yosemite
    sha256 "d1c37d46cbef0781ab1078d390b530f805e731ca7ed1272225db6f32d4c04b23" => :mavericks
    sha256 "943dd756f97b6c787f86cd95b150cab78d70d673648a2209b867e58ee4827906" => :mountain_lion
    sha256 "7c6252a1734df9bfaf90ae8c3d702aa578e7968621d5258a37bd10a4beb54d03" => :x86_64_linux
  end

  head do
    url "https://github.com/bcgsc/abyss.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  option :cxx11
  option "with-maxk=", "Set the maximum k-mer length to N [default is 96]"
  option "without-test", "Skip build-time tests (not recommended)"
  option "with-openmp", "Enable OpenMP multithreading"

  deprecated_option "enable-maxk" => "with-maxk"
  deprecated_option "without-check" => "without-test"

  needs :openmp if build.with? "openmp"

  # Only header files are used from these packages, so :build is appropriate
  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on "sqlite" unless OS.mac?
  depends_on :mpi => [:cc, :recommended]

  # strip breaks the ability to read compressed files.
  skip_clean "bin"

  def install
    ENV.cxx11 if build.cxx11?
    system "./autogen.sh" if build.head?

    args = [
      "--enable-maxk=#{ARGV.value("with-maxk") || 96}",
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
    ]

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/ABYSS", "--version"
  end
end
