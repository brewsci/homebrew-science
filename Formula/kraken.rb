class Kraken < Formula
  desc "Assign taxonomic labels to short DNA sequences"
  homepage "https://ccb.jhu.edu/software/kraken/"
  url "https://ccb.jhu.edu/software/kraken/dl/kraken-1.0.tgz"
  sha256 "cec40d3545199d48388269fc1b7fda9f48ae3aa73f99ed4410e1474abe421e6a"
  head "https://github.com/DerrickWood/kraken.git"
  # doi "10.1186/gb-2014-15-3-r46"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "67ca2a920ec77a34271f46b138cfbffa9bd35ede29e021350ed72366ca39ed76" => :high_sierra
    sha256 "075189b2bf64ff8ba6d9dab9295581729c34204b53fe531c911ffdc947521319" => :sierra
    sha256 "6d708f5ba2ef470a24784b7d9b776bf36769014ac26a980d0ca3bf1d7a75875a" => :el_capitan
    sha256 "fa4df8c8e57cf2f53b05ec9cb8e0147ad7e9da1f09e59b12c40c476c7e41714b" => :x86_64_linux
  end

  needs :openmp

  def install
    libexec.mkdir
    system "./install_kraken.sh", libexec
    libexec_bins = ["kraken", "kraken-build", "kraken-filter", "kraken-mpa-report", "kraken-report", "kraken-translate"].map { |x| libexec + x }
    bin.install_symlink(libexec_bins)
  end

  test do
    system "#{bin}/kraken", "--version"
  end
end
