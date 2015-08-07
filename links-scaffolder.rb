class LinksScaffolder < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  # doi "10.1186/s13742-015-0076-3"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/links/releases/1.5.1/links_v1-5-1.tar.gz"
  version "1.5.1"
  sha256 "3f4dbcdd0fc6735ae316d7c379b038a3fada16233a120b2d6f2220d51a24a908"

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
