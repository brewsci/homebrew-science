require "formula"

class Reapr < Formula
  homepage "https://www.sanger.ac.uk/resources/software/reapr/"
  url "ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_1.0.17.tar.gz"
  sha1 "4d2a8856a6d19d259aeec8591a024ba598003acc"

  depends_on "bamtools"
  depends_on "samtools"
  depends_on "tabix"

  depends_on "File::Spec::Link" => :perl

  def install
    system *%W[make -C src/tabix]
    system *%W[make -C src
      CFLAGS=-I#{Formula["bamtools"].opt_include}/bamtools]
    doc.install %w[README changelog.txt licence.txt]
    cd "src" do
      libexec.install %w[bam2fcdEstimate bam2fragCov bam2insert
        bam2perfect fa2gaps fa2gc make_plots n50 scaff2contig
        task_break task_fcdrate task_gapresize task_score task_stats
        task_facheck.pl task_perfectfrombam.pl task_perfectmap.pl
        task_plots.pl task_preprocess.pl task_smaltmap.pl
        task_summary.pl reapr.pl]
    end
    bin.install_symlink libexec+"reapr.pl" => "reapr"
  end

  test do
    system "#{bin}/reapr 2>&1 |grep -q reapr"
  end
end
