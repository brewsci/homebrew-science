require "formula"

class Reapr < Formula
  homepage "https://www.sanger.ac.uk/resources/software/reapr/"
  url "ftp://ftp.sanger.ac.uk/pub/resources/software/reapr/Reapr_1.0.16.tar.gz"
  sha1 "8001ba02d5c0db9a895c48dd32dd7b77d95723bf"

  depends_on "bamtools"
  depends_on "samtools"
  depends_on "tabix"

  depends_on "File::Spec::Link" => :perl

  def install
    system *%W[make -C src/tabix]
    system *%W[make -C src
      CFLAGS=-I#{Formula["bamtools"].opt_prefix/"include/bamtools"}]
    bin.install "src/reapr.pl" => "reapr"
    doc.install %w[README changelog.txt licence.txt manual.pdf]
    cd "src" do
      libexec.install %w[bam2fcdEstimate bam2fragCov bam2insert
        bam2perfect fa2gaps fa2gc make_plots n50 scaff2contig
        task_break task_fcdrate task_gapresize task_score task_stats
        task_facheck.pl task_perfectfrombam.pl task_perfectmap.pl
        task_plots.pl task_preprocess.pl task_smaltmap.pl
        task_summary.pl]
    end
  end

  test do
    system "#{bin}/reapr 2>&1 |grep -q reapr"
  end
end
