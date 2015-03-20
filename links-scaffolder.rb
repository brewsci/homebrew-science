class LinksScaffolder < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  # doi "10.1101/016519"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/links/releases/1.1/links_v1-1.tar.gz"
  version "1.1"
  sha256 "c27f2e0a2ae21f51dd0a0a141bb65a8a200d75482fa94724310a764b202b7227"

  def install
    bin.install "LINKS"
    chmod 0644, "LINKS-readme.txt"
    doc.install "LINKS-readme.txt"
    prefix.install "test"
  end

  test do
    assert_match "LINKS", shell_output("#{bin}/LINKS", 255)
  end
end
