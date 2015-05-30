class SimulatePcr < Formula
  desc "Predicts amplicon products from single or multiplex primers"
  homepage "https://sourceforge.net/projects/simulatepcr/"

  # doi "10.1186/1471-2105-15-237"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/simulatepcr/simulate_PCR-v1.2.tar.gz"
  sha256 "022d1cc595d78a03b6a8a982865650f99d9fa067997bfea574c2416cc462e982"

  depends_on "blast"
  depends_on "Bio::Perl" => :perl
  depends_on "edirect" => :optional

  def install
    bin.install "simulate_PCR"
  end

  test do
    assert_match "amplicon", shell_output("#{bin}/simulate_PCR 2>&1", 255)
  end
end
