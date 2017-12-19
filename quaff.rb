class Quaff < Formula
  desc "Pair HMM for aligning FASTQ to FASTA reference"
  homepage "https://github.com/ihh/quaff"
  url "https://github.com/ihh/quaff/archive/v0.1-alpha.1.tar.gz"
  version "0.1.1"
  sha256 "dc46b8c2fafcd6c5d2322006b47fda7d1877f9ea3a105d2ecaf4ab178d8eb8dd"
  revision 3
  head "https://github.com/ihh/quaff.git"
  # tag "bioinformatics"

  bottle :disable, "needs to be rebuilt with latest boost"

  depends_on "zlib" unless OS.mac?
  depends_on "pkg-config" => :build
  depends_on "boost" => :recommended
  depends_on "gsl"
  depends_on "awscli" => :optional

  needs :cxx11

  def install
    # .linuxbrew/lib/libpthread.so.0: error adding symbols: DSO missing from command line
    inreplace "Makefile", "LIBFLAGS = ", "LIBFLAGS = -lpthread "
    system "make",
      "PREFIX=#{prefix}",
      "CPP=#{ENV.cxx}",
      "GSLPREFIX=#{Formula["gsl"].opt_prefix}",
      "BOOSTPREFIX=#{Formula["boost"].opt_prefix}",
      "quaff"
    rm_r %w[xcode src kseq perl t]
    prefix.install Dir["*"]
  end

  test do
    assert_match "Viterbi", shell_output("#{bin}/quaff help 2>&1", 0)
  end
end
