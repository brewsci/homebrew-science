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
    sha256 "6c0b06cc672b077fe85d00e477d86b7132f8ae77631597eb5fed2f54ba8bd5bc" => :el_capitan
    sha256 "af309c5203e760859f2b434b23259c15cbc3cb29efc3d3b686607a31d501d7ab" => :yosemite
    sha256 "a3fd8a9126721dccf37745b476847eaa9b1393bc10c5f29eb2ac28a2458af7cc" => :mavericks
    sha256 "95b4c713acc165bb6fb9af533a24f8228f9cfd0b7e10233d4a9eee7573266ba5" => :x86_64_linux
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
