class LinksScaffolder < Formula
  desc "Long Interval Nucleotide K-mer Scaffolder"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  url "http://www.bcgsc.ca/platform/bioinfo/software/links/releases/1.5.2/links_v1-5-2.tar.gz"
  version "1.5.2"
  sha256 "3ac4b6287896955759b03993128618616d0ab2f5535b2de91ef2b799819ad707"
  # doi "10.1186/s13742-015-0076-3"
  # tag "bioinformatics"

  bottle :unneeded

  depends_on "Bloom::Faster" => :perl

  def install
    bin.install "LINKS"
    chmod 0644, "LINKS-readme.txt"
    doc.install "LINKS-readme.txt"
    doc.install "LINKS-readme.pdf"
    prefix.install "test"
    prefix.install "tools"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/LINKS", 255)
  end
end
