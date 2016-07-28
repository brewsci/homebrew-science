class Rcorrector < Formula
  desc "Error correction for Illumina RNA-seq reads"
  homepage "https://github.com/mourisl/Rcorrector"
  url "https://github.com/mourisl/Rcorrector/archive/v1.0.2.tar.gz"
  sha256 "426c7ab5fbb968536dbb4daf6913599f99b50eaabbea8013930da77f1235d9c6"
  head "https://github.com/mourisl/Rcorrector.git"
  # doi "10.1186/s13742-015-0089-y"
  # tag "bioinformatics"

  depends_on "jellyfish"

  def install
    system "make"
    bin.install "rcorrector", "run_rcorrector.pl"
    doc.install "LICENSE", "README.md", "Sample"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/rcorrector 2>&1")
    assert_match "Usage", shell_output("#{bin}/run_rcorrector.pl 2>&1", 255)
  end
end
