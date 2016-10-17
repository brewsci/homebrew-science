class KentTools < Formula
  desc "Utilities for the UCSC Genome Browser"
  homepage "http://genome.ucsc.edu/"
  url "http://hgdownload.soe.ucsc.edu/admin/exe/userApps.v339.src.tgz"
  sha256 "8de1450dae123cfc6953b77b40c28e945d2278a0b0cf2ef0c36e5c373b234bee"
  head "git://genome-source.cse.ucsc.edu/kent.git"

  bottle do
    cellar :any
    sha256 "7d9c3b389ad5407ae662135fbc6b91d41364958b7440b74e5985b08a01c99fe6" => :el_capitan
    sha256 "ed11a1d33911cba7d872049bbf6ce059301b7fd48943666c52d8763462574610" => :yosemite
    sha256 "dd9c9cf5b6f2172d0a2ac81411d6c153925a5c27b05ad783d353403f751a205d" => :mavericks
  end

  depends_on :mysql
  depends_on "libpng"
  depends_on "openssl"

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
