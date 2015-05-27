class KentTools < Formula
  desc "Utilities for the UCSC Genome Browser"
  homepage "http://genome.ucsc.edu/"
  url "http://hgdownload.cse.ucsc.edu/admin/exe/userApps.v316.src.tgz"
  head "git://genome-source.cse.ucsc.edu/kent.git"
  sha256 "1190e52702ff2661ac48fe4f0ef9f966718f44ec09596a6f77c8049c638a59fe"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "0b436198f2e9041baa7e7982093376410176c39d9be953c8f7941112f7c57ee9" => :yosemite
    sha256 "0dd2eb9c9167224e9fa0a0c78bd7d4cbdc9f3f9c708fe1f540c3345f3fcec07c" => :mavericks
    sha256 "e16188ebf456226abf5dbe34e44fe33026864febd42e732b752f36e8e075867c" => :mountain_lion
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
