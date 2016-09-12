class KentTools < Formula
  desc "Utilities for the UCSC Genome Browser"
  homepage "http://genome.ucsc.edu/"
  url "http://hgdownload.soe.ucsc.edu/admin/exe/userApps.v337.src.tgz"
  sha256 "17b5d039ca63fe537a9b8a6d3babf5fe9274ffd25b4ae53f2ea49e8905b0c0a4"
  head "git://genome-source.cse.ucsc.edu/kent.git"

  bottle do
    cellar :any
    sha256 "75a15c558cbbfbf3aa6a3309e94eb8ae30beb17742e7243ea185ca1f97f595e8" => :el_capitan
    sha256 "11702a6c3f3c9886c602d4e05406040b638e1ebf719bf8306e96e83fa925ab9a" => :yosemite
    sha256 "080ffeffb96e3f3d7c4d73e03ae9d55c9c37eda57adc012345c04fb0004ea297" => :mavericks
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
