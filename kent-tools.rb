class KentTools < Formula
  desc "Utilities for the UCSC Genome Browser"
  homepage "https://genome.ucsc.edu/"
  url "http://hgdownload.soe.ucsc.edu/admin/exe/userApps.v353.src.tgz"
  sha256 "f3e7609069b195ef5219e39e0181ced1988f8d3843579d36549fc47e808b27a1"
  head "git://genome-source.cse.ucsc.edu/kent.git"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "0182493728c26b8c04e5a1ac784d92fb8550f6f5f88288e1c2436f580f4fe180" => :sierra
    sha256 "a99b9cd252b872d9ae85652bbb7f9fea0e219982b31b03b8038f1e1fa5403302" => :el_capitan
    sha256 "6d2f37da7f672f4d8a33bb3d05a1c3080b7133ed104a7143f07a5128fa53241b" => :yosemite
  end

  depends_on :mysql
  depends_on "libpng"
  depends_on "openssl"
  depends_on "util-linux" unless OS.mac?
  depends_on "zlib" unless OS.mac?

  def install
    libpng = Formula["libpng"]
    mysql = Formula["mysql"]

    args = ["userApps", "BINDIR=#{bin}", "SCRIPTS=#{bin}"]
    args << "MACHTYPE=#{`uname -m`.chomp}"
    args << "PNGLIB=-L#{libpng.opt_lib} -lpng -lz"
    args << "PNGINCL=-I#{libpng.opt_include}"

    # On Linux, depends_on :mysql looks at system MySQL so check if Homebrew
    # MySQL already exists. If it does, then link against that. Otherwise, let
    # kent-tools link against system MySQL (see kent/src/inc/common.mk)
    if mysql.installed?
      args << "MYSQLINC=#{mysql.opt_include}/mysql"
      args << "MYSQLLIBS=-lmysqlclient -lz"
    end

    cd build.head? ? "src" : "kent/src" do
      system "make", *args
    end

    cd bin do
      blat_bin = %w[blat faToTwoBit gfClient gfServer nibFrag pslPretty
                    pslReps pslSort twoBitInfo twoBitToFa]
      rm blat_bin
      mv "calc", "kent-tools-calc"
    end
  end

  def caveats; <<-EOS.undent
    The `calc` tool has been renamed to `kent-tools-calc`.

    This only installs the standalone tools located at
      http://hgdownload.cse.ucsc.edu/admin/exe/

    If you need the full UCSC Genome Browser, run:
      brew install ucsc-genome-browser

    This does not install the BLAT tools. To install BLAT:
      brew install blat
    EOS
  end

  test do
    (testpath/"test.fa").write <<-EOF.undent
      >test
      ACTG
    EOF
    system "#{bin}/faOneRecord test.fa test > out.fa"
    compare_file "test.fa", "out.fa"
  end
end
