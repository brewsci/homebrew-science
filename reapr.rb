class Reapr < Formula
  homepage "https://www.sanger.ac.uk/resources/software/reapr/"
  url "ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_1.0.17.tar.gz"
  sha1 "4d2a8856a6d19d259aeec8591a024ba598003acc"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "f31e1933d3472e02798db71c0a556e8700fadacb" => :yosemite
    sha1 "07fe3f9f162afa5908018ef0501c0e59aa2d545f" => :mavericks
    sha1 "695744fc78fd1b5dde72bcad87e80c3606c853c2" => :mountain_lion
  end

  depends_on "bamtools"
  depends_on "samtools-0.1"
  depends_on "tabix"

  resource "File::Spec::Link" do
    url "http://search.cpan.org/CPAN/authors/id/R/RM/RMBARKER/File-Copy-Link-0.140.tar.gz"
    sha1 "515178bc42ab25eb2248bd5fb854e1c805fdf12d"
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
