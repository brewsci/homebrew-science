class Quaff < Formula
  desc "Pair HMM for aligning FASTQ to FASTA reference"
  homepage "https://github.com/ihh/quaff"
  url "https://github.com/ihh/quaff/archive/v0.1-alpha.1.tar.gz"
  version "0.1.1"
  sha256 "dc46b8c2fafcd6c5d2322006b47fda7d1877f9ea3a105d2ecaf4ab178d8eb8dd"
  revision 1
  head "https://github.com/ihh/quaff.git"
  # tag "bioinformatics"

  bottle do
    sha256 "fecf7c9febbc1e297a34478efffecf14cb7feffea7ede8581e12b81320875128" => :sierra
    sha256 "862e1835bbb3323c660f967c4eff050218e3af3bc2bf83e68b67fce7a174aecd" => :el_capitan
    sha256 "d2285c4d9423cc1cf0b4260e1f39dbbbf417622296062af529ceed30d643be7c" => :yosemite
  end

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
