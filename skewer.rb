class Skewer < Formula
  homepage "http://sourceforge.net/projects/skewer/"
  # tag "bioinformatics"
  # doi "10.1186/1471-2105-15-182"

  url "https://github.com/relipmoc/skewer.git",
    :revision => "c61bb90eeb558d9bbad862e1b3b1ad6a6b42c8e3"
  version "0.1.124"

  def install
    system "make", "CXXFLAGS=-O2 -c"
    bin.install "skewer"
    doc.install "README.md", "LICENSE"
  end

  test do
    assert_match "Nextera", shell_output("skewer --help 2>&1", 1)
  end
end
