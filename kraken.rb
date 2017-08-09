class Kraken < Formula
  desc "Assign taxonomic labels to short DNA sequences"
  homepage "https://ccb.jhu.edu/software/kraken/"
  url "https://ccb.jhu.edu/software/kraken/dl/kraken-0.10.5-beta.tgz"
  sha256 "7c0ac64ee0acdcce18e16b51b636b7cdc6d07ea7ab465bb64df078c5a710346b"
  # doi "10.1186/gb-2014-15-3-r46"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "8aa0b49d43549c08ab6dbad12cf0a5e2762b5c8f020a9e57019880a5ab0aeda9" => :yosemite
    sha256 "2f2bf03509e930ee0dd6080ec81fe73dc2bc271d0adf40e198edb898e6f77860" => :mavericks
    sha256 "7dd3ad72403d173bb5cab35a51099e20bc7408c2148376dbc08edadc4ed1fa5e" => :mountain_lion
    sha256 "83b2bf3cffec73b1dc01496d32478fda703a406eb2ccdc32867a12103f3d624f" => :x86_64_linux
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
