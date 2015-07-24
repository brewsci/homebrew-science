class Kraken < Formula
  homepage "http://ccb.jhu.edu/software/kraken/"
  url "https://ccb.jhu.edu/software/kraken/dl/kraken-0.10.5-beta.tgz"
  sha256 "7c0ac64ee0acdcce18e16b51b636b7cdc6d07ea7ab465bb64df078c5a710346b"

  bottle do
    cellar :any
    sha256 "8aa0b49d43549c08ab6dbad12cf0a5e2762b5c8f020a9e57019880a5ab0aeda9" => :yosemite
    sha256 "2f2bf03509e930ee0dd6080ec81fe73dc2bc271d0adf40e198edb898e6f77860" => :mavericks
    sha256 "7dd3ad72403d173bb5cab35a51099e20bc7408c2148376dbc08edadc4ed1fa5e" => :mountain_lion
  end

  needs :openmp

  def install
    libexec.mkdir
    inreplace "install_kraken.sh", "[ -x \"$file\" ] && echo \"  $file\"", "if [ -x \"$file\" ]; then echo \"  $file\"; fi"
    system "./install_kraken.sh", libexec
    libexec_bins = ["kraken", "kraken-build", "kraken-filter", "kraken-mpa-report", "kraken-report", "kraken-translate"].map { |x| libexec + x }
    bin.install_symlink(libexec_bins)
  end

  test do
    system "#{bin}/kraken", "--version"
  end
end
