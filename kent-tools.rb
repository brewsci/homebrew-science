class KentTools < Formula
  desc "Utilities for the UCSC Genome Browser"
  homepage "http://genome.ucsc.edu/"
  url "http://hgdownload.cse.ucsc.edu/admin/exe/userApps.v316.src.tgz"
  head "git://genome-source.cse.ucsc.edu/kent.git"
  sha256 "1190e52702ff2661ac48fe4f0ef9f966718f44ec09596a6f77c8049c638a59fe"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "9c5e426ee9255fe8a04ac510e52e8e1830ed5657d99ec2a9dae25eb90c1308d8" => :yosemite
    sha256 "6f869c09ee9c3a33bf8f69b75dfefaa456346879104268b26e4f9057a1276db5" => :mavericks
    sha256 "29cd9e14a04bb59dafe8c87a3d9e96f19cabcef98118eaba5c04ca66bd6dae4b" => :mountain_lion
  end

  depends_on :mysql
  depends_on "libpng"
  depends_on "openssl"

  def install
    libpng = Formula["libpng"]
    mysql = Formula["mysql"]

    args = ["userApps", "BINDIR=#{bin}", "SCRIPTS=#{bin}"]
    args << "MACHTYPE=#{`uname -m`.chomp}"
    args << "PNGLIB=-L#{libpng.opt_lib} -lpng"
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
