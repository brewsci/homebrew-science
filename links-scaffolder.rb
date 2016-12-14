class LinksScaffolder < Formula
  desc "Long Interval Nucleotide K-mer Scaffolder"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  url "http://www.bcgsc.ca/platform/bioinfo/software/links/releases/1.6.1/links_v1-6-1.tar.gz"
  version "1.6.1"
  sha256 "c4fa4f39dbee49c484521a80738758a39dc21b4a594d3e3fcf231d4decfdbe97"
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
