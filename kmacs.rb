class Kmacs < Formula
  desc "k Mismatch Average Common Substring Approach"
  homepage "http://kmacs.gobics.de/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu331"

  url "http://kmacs.gobics.de/content/kmacs.tar.gz"
  version "20140605"
  sha256 "39330272fa3436717a240270c35850caf2a65f4a1f395fabeb79c4802d9594fe"

  def install
    system "make"
    bin.install "kmacs"
    doc.install "README"
  end

  test do
    assert_match "file.fasta k", shell_output("#{bin}/kmacs 2>&1", 1)
  end
end
