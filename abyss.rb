class Abyss < Formula
  desc "ABySS: genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  # doi "10.1101/gr.089532.108"
  # tag "bioinformatics"

  url "https://github.com/bcgsc/abyss/releases/download/1.9.0/abyss-1.9.0.tar.gz"
  sha256 "1030fcea4bfae942789deefd3a4ffb30653143e02eb6a74c7e4087bb4bf18a14"
  revision 2

  bottle do
    cellar :any
    sha256 "231aa5e27f85f78b4ce75bba5bb1448b106f6650b1befc190fc3563ce4a18196" => :el_capitan
    sha256 "68e20ab489764668d1f56041899849d19466824125133901e0e9d92c6dc01c55" => :yosemite
    sha256 "aa5e6a5d3e4007f1b7d592a67612aa6b49a9f4536dbf07c068390de750400c8f" => :mavericks
    sha256 "6a9574678706b7a78ebca7617f21d554d27041aa32427fe4370f03cbbe68f182" => :x86_64_linux
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
