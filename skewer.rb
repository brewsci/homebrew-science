class Skewer < Formula
  homepage "http://sourceforge.net/projects/skewer/"
  # tag "bioinformatics"
  # doi "10.1186/1471-2105-15-182"

  url "https://github.com/relipmoc/skewer.git",
    :revision => "c61bb90eeb558d9bbad862e1b3b1ad6a6b42c8e3"
  version "0.1.124"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "eb3863b75964499df80d3033bcaa8f97808f127d1282698ead72ce255d82302f" => :yosemite
    sha256 "6b1184f8166e7f554624e32451fc3ce5bdfdd605abfe0a8b127199b48a088f7b" => :mavericks
    sha256 "f6f77ea2c2aa17c9d3e32c9762fae6734f91c3ed368b91207499f1abbbfbd70b" => :mountain_lion
  end

  def install
    system "make", "CXXFLAGS=-O2 -c"
    bin.install "skewer"
    doc.install "README.md", "LICENSE"
  end

  test do
    assert_match "Nextera", shell_output("skewer --help 2>&1", 1)
  end
end
