class LinksScaffolder < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  # doi "10.1101/016519"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/links/releases/1.5/links_v1-5.tar.gz"
  version "1.5"
  sha256 "b06f7d4c4c9de4e6c723d54fd2a2786f236a295166d3d36b9a166ecab36c5161"

  depends_on "Bloom::Faster" => :perl

  def install
    bin.install "LINKS"
    chmod 0644, "LINKS-readme.txt"
    doc.install "LINKS-readme.txt"
    chmod 0644, "LINKS-readme.pdf"
    doc.install "LINKS-readme.pdf"
    prefix.install "test"
    prefix.install "tools"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/LINKS", 255)
  end
end
