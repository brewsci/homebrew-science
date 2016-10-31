class KentTools < Formula
  desc "Utilities for the UCSC Genome Browser"
  homepage "http://genome.ucsc.edu/"
  url "http://hgdownload.soe.ucsc.edu/admin/exe/userApps.v339.src.tgz"
  sha256 "8de1450dae123cfc6953b77b40c28e945d2278a0b0cf2ef0c36e5c373b234bee"
  head "git://genome-source.cse.ucsc.edu/kent.git"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "356b9196c81db579621b822cc495c9367de1a553ea8db767f6a2ccc794cff2dc" => :sierra
    sha256 "2b43e396a7686d7700bc53572e42f0942545e116ed299f8afffe766a31d10adc" => :el_capitan
    sha256 "bf17f561123f84ebf13bfaee93d9c3f20f26f02dd8823dd330d25b9939f971fe" => :yosemite
    sha256 "65f6bb521972b42ad08cb9355f68937053688159aa5c50ee649869ee34f8d2d2" => :x86_64_linux
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
