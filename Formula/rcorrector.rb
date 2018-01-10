class Rcorrector < Formula
  desc "Error correction for Illumina RNA-seq reads"
  homepage "https://github.com/mourisl/Rcorrector"
  url "https://github.com/mourisl/Rcorrector/archive/v1.0.2.tar.gz"
  sha256 "426c7ab5fbb968536dbb4daf6913599f99b50eaabbea8013930da77f1235d9c6"
  head "https://github.com/mourisl/Rcorrector.git"
  # doi "10.1186/s13742-015-0089-y"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "652a86c2cc09aea5dd00038e2ed9ab3776f9cc086e0859274763b510aa78ee1d" => :el_capitan
    sha256 "9d6f6a32d1bf8d19635f46a48e5062f2ca35dd1014a2f9e4e016a16eb7f40a47" => :yosemite
    sha256 "d3cef8dc62cb87cb197b40c3beb00d28a667f3ccdbde24e953f1393bc7c01c57" => :mavericks
    sha256 "1ceb79a2fb8fc8d148b04ed638d70faf120d88017ebd211e9ec5b4f0a1d5c034" => :x86_64_linux
  end

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
