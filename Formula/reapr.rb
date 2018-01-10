class Reapr < Formula
  desc "Evaluates accuracy of a genome assembly using mapped paired end reads"
  homepage "https://www.sanger.ac.uk/science/tools/reapr"
  # doi "10.1186/gb-2013-14-5-r47"
  # tag "bioinformatics"
  url "ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_1.0.18.tar.gz"
  sha256 "6d691b5b49c58aef332e771d339e32097a7696e9c68bd8f16808b46d648b6660"
  revision 2

  bottle do
    cellar :any
    sha256 "9290a6fe394b119c2a0fc78ee496a2537c82cc5501f877610cdf2878b50d6f9a" => :sierra
    sha256 "1b1a226fe7e1e9816bd51d48b99728c1a908ee24653bc5c6978ce6bfbbe27091" => :el_capitan
    sha256 "4eb95ffaafb77525a0ae8ff54a0eb0ba853c519472ac7274aa1f915892ec0971" => :yosemite
  end

  depends_on "bamtools"
  depends_on "htslib"
  depends_on "r" => [:recommended, :run] # only needed for the test
  depends_on "smalt"

  resource "manual" do
    url "ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_1.0.18.manual.pdf"
    sha256 "304b7b7b725abc285791d8be3b2aaf6f4afeb38852ce91fa5635dc0a9913a517"
  end

  resource "test_data" do
    url "ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_1.0.18.test_data.tar.gz"
    sha256 "6ef426e56c4854cdbb22d7012aca29d22b072de5e63f505be11229df76b12840"
  end

  resource "File::Spec::Link" do
    url "http://search.cpan.org/CPAN/authors/id/R/RM/RMBARKER/File-Copy-Link-0.140.tar.gz"
    sha256 "2063656dcd38bade43dc7f1e2ef5f1b6a8086c2f15d37b334189bd2a28e8ffeb"
  end

  # Fix "Undefined symbol error for "___ks_insertsort_heap"
  # Upstream SAMtools commit from 10 Dec 2012 "ksort.h: declared
  # __ks_insertsort_##name as static to compile with C99."
  resource "samtools_patch" do
    url "https://github.com/samtools/samtools/commit/64275b4.patch"
    sha256 "91ad8e714c0d48a7b3dde99eb4eba49c00b8e88f0c4b67cdd284c208a4741803"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("File::Spec::Link").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    if OS.mac?
      inreplace "third_party/snpomatic/src/snpomatic.h",
        "using namespace std ;",
        "using namespace std ;\n#define ulong u_long"
    end

    resource("samtools_patch").stage do
      system "patch", "-p1", "-i", Pathname.pwd/"64275b4.patch", "-d",
                      buildpath/"third_party/samtools-0.1.18"
    end

    # use the vendored samtools-0.1 to avoid CI conflicts
    system "make", "-C", "third_party/samtools"
    system "make", "-C", "third_party/samtools", "razip"
    system "make", "-C", "third_party/tabix"
    system "make", "-C", "third_party/snpomatic"

    system "make", "-C", "src",
      "CFLAGS=-I#{Formula["bamtools"].opt_include}/bamtools"
    doc.install %w[README changelog.txt licence.txt]
    doc.install resource("manual")
    (pkgshare/"test").install resource("test_data")

    cd "src" do
      libexec.install %w[
        bam2fcdEstimate bam2fragCov bam2insert
        bam2perfect fa2gaps fa2gc make_plots n50 scaff2contig
        task_break task_fcdrate task_gapresize task_score task_stats
        task_facheck.pl task_perfectfrombam.pl task_perfectmap.pl
        task_pipeline.pl task_plots.pl task_preprocess.pl task_smaltmap.pl
        task_summary.pl reapr.pl
      ]
    end

    bin.install_symlink libexec/"reapr.pl" => "reapr"
    libexec.install_symlink Formula["htslib"].opt_bin => "tabix"
    libexec.install_symlink Formula["smalt"].opt_bin/"smalt" => "smalt"
    cd "third_party/samtools" do
      libexec.install %w[samtools razip]
      (libexec/"share/man/man1").install "samtools.1"
    end
    cd "third_party/samtools/bcftools" do
      libexec.install %w[bcftools vcfutils.pl]
      (libexec/"share/doc/bcftools").install "bcf.tex"
    end
    cd "third_party/samtools/misc" do
      (libexec/"samtools-misc").install Dir["*.java"]
      (libexec/"samtools-misc").install Dir["*.pl"]
      (libexec/"samtools-misc").install Dir["*.py"]
      (libexec/"samtools-misc").install %w[
        maq2sam-long maq2sam-short md5sum-lite seqtk wgsim
      ]
    end
    libexec.install "third_party/snpomatic/findknownsnps"
    bin.env_script_all_files(libexec, :PERL5LIB => ENV["PERL5LIB"])
    ln_s bin/"reapr", prefix/"reapr"
  end

  test do
    cp_r Dir[pkgshare/"test/*"], testpath
    system "./test.sh"
  end
end
