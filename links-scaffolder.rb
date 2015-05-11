class LinksScaffolder < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  # doi "10.1101/016519"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/links/releases/1.5/links_v1-5.tar.gz"
  version "1.5"
  sha256 "20b42024fa9da153512167c1ec4ebe75bfbf1118642e1ac964f40cabc400df04"

  depends_on "Bloom::Faster" => :perl

  def install
    bin.install "LINKS"
    chmod 0644, "LINKS-readme.txt"
    doc.install "LINKS-readme.txt"
    prefix.install "test"
    prefix.install "tools"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/LINKS", 255)
  end
end
