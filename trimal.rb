class Trimal < Formula
  homepage "http://trimal.cgenomics.org/"
  # doi "10.1093/bioinformatics/btp348"
  # tag "bioinformatics"
  head "https://github.com/scapella/trimal"

  url "https://github.com/scapella/trimal/archive/v1.4.1.tar.gz"
  sha256 "cb8110ca24433f85c33797b930fa10fe833fa677825103d6e7f81dd7551b9b4e"

  def install
    system "make", "-C", "source", "CC=c++"
    bin.install "source/readal", "source/trimal", "source/statal"
    share.install "dataset"
    doc.install %w[AUTHORS CHANGELOG LICENSE README]
  end

  test do
    assert_match "Salvador", shell_output("trimal 2>&1", 0)
    assert_match "Salvador", shell_output("readal 2>&1", 0)
    assert_match "Salvador", shell_output("statal 2>&1", 0)
  end
end
