class Kraken < Formula
  homepage "http://ccb.jhu.edu/software/kraken/"
  url "https://ccb.jhu.edu/software/kraken/dl/kraken-0.10.5-beta.tgz"
  sha256 "7c0ac64ee0acdcce18e16b51b636b7cdc6d07ea7ab465bb64df078c5a710346b"

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
