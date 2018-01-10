class AsciiPlots < Formula
  desc "Quick and dirty data analysis"
  homepage "https://github.com/dzerbino/ascii_plots.git"

  url "https://github.com/dzerbino/ascii_plots/archive/1.0.tar.gz"
  sha256 "db5b3ad230316f88537c274fec53c24aa1d20d0eedf92853fcc8e1412b0edba7"

  head "https://github.com/dzerbino/ascii_plots.git"

  bottle do
    cellar :any
    sha256 "350c067eab3921083ea7216527895fd9098bb8eddc14bfad2a6e619e24ea5e33" => :yosemite
    sha256 "3c19b4a2cd1a3d69e313f2452a7dc244354cf5ef2dcf77f27c6c6052d541aa23" => :mavericks
    sha256 "443d1ba0e08aab9bc9d17ef5f5b6e2fbd2ca955dd064844239c4796573942b50" => :mountain_lion
  end

  def install
    bin.install %w[cor curve hist scatter summary]
    doc.install %w[README.md demo.sh test.tsv]
  end

  test do
    system "#{bin}/summary <<<'1 4 9'"
  end
end
