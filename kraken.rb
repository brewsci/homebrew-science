require "formula"

class Kraken < Formula
  homepage "http://ccb.jhu.edu/software/kraken/"
  url "http://ccb.jhu.edu/software/kraken/dl/kraken-0.10.3-beta.tgz"
  sha1 "64f88004c341871d883235f4ae7c876c0136b885"

  needs :openmp

  def install
    libexec.mkdir
    system "./install_kraken.sh", libexec
    libexec_bins = ["kraken", "kraken-build", "kraken-report"].map { |x| libexec + x }
    bin.install_symlink(libexec_bins)
  end

  test do
    system "kraken", "--version"
  end
end
