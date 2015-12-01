class Reapr < Formula
  homepage "https://www.sanger.ac.uk/resources/software/reapr/"
  # doi "10.1186/gb-2013-14-5-r47"
  # tag "bioinformatics"
  url "ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_1.0.17.tar.gz"
  sha256 "e235d846447a34fffa6765fbbea2407cc0c6a0217c007f196e5786022034b65e"

  bottle do
    sha256 "13aed3f265e22d890dde4b91e7bd3965151f1724560e2548362b63d1a2597cf3" => :yosemite
    sha256 "4d815482a30e0377c74241049375e1aa0cdfa87ecb4c20c18ba8cf4e028808bc" => :mavericks
    sha256 "c0ac706f9a675419c5ccb7049ba373b6564c5cd5cfc24ecee93d26b002ebb7af" => :mountain_lion
  end

  depends_on "bamtools"
  depends_on "samtools-0.1"
  depends_on "tabix"

  resource "File::Spec::Link" do
    url "http://search.cpan.org/CPAN/authors/id/R/RM/RMBARKER/File-Copy-Link-0.140.tar.gz"
    sha256 "2063656dcd38bade43dc7f1e2ef5f1b6a8086c2f15d37b334189bd2a28e8ffeb"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("File::Spec::Link").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "make", "-C", "src/tabix"
    system "make", "-C", "src",
           "CFLAGS=-I#{Formula["bamtools"].opt_include}/bamtools"
    doc.install %w[README changelog.txt licence.txt]

    cd "src" do
      libexec.install %w[
        bam2fcdEstimate bam2fragCov bam2insert
        bam2perfect fa2gaps fa2gc make_plots n50 scaff2contig
        task_break task_fcdrate task_gapresize task_score task_stats
        task_facheck.pl task_perfectfrombam.pl task_perfectmap.pl
        task_plots.pl task_preprocess.pl task_smaltmap.pl
        task_summary.pl reapr.pl
      ]
    end
    bin.install_symlink libexec+"reapr.pl" => "reapr"
    bin.env_script_all_files(libexec, :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system "#{bin}/reapr 2>&1 |grep -q reapr"
  end
end
