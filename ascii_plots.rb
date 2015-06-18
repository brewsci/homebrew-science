class AsciiPlots < Formula
  desc "Quick and dirty data analysis"
  homepage "https://github.com/dzerbino/ascii_plots.git"

  url "https://github.com/dzerbino/ascii_plots/archive/1.0.tar.gz"
  sha256 "db5b3ad230316f88537c274fec53c24aa1d20d0eedf92853fcc8e1412b0edba7"

  head "https://github.com/dzerbino/ascii_plots.git"

  def install
    bin.install %w[cor curve hist scatter summary]
    doc.install %w[README.md demo.sh test.tsv]
  end

  test do
    system "#{bin}/summary <<<'1 4 9'"
  end
end
