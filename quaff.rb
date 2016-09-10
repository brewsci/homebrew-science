class Quaff < Formula
  desc "Pair HMM for aligning FASTQ to FASTA reference"
  homepage "https://github.com/ihh/quaff"
  url "https://github.com/ihh/quaff/archive/v0.1-alpha.1.tar.gz"
  version "0.1.1"
  sha256 "dc46b8c2fafcd6c5d2322006b47fda7d1877f9ea3a105d2ecaf4ab178d8eb8dd"
  head "https://github.com/ihh/quaff.git"
  # tag "bioinformatics"

  bottle do
    sha256 "3f413816fddd91a49b47f9a04e3afdc4556147c07dfcc24f622914b2b1f5b500" => :el_capitan
    sha256 "98b3ed8fc748ad7ae9dea576831e4c3228635f35929dd9258f8c4c30c5eb9117" => :yosemite
    sha256 "2a7f6e1dfa6dd01fc96e904a84e285bec9db8338a873e9412a46fe82f6c45bca" => :mavericks
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
