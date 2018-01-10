class Skewer < Formula
  desc "Fast and accurate NGS adapter trimmer"
  homepage "https://github.com/relipmoc/skewer"
  url "https://github.com/relipmoc/skewer/archive/0.2.2.tar.gz"
  sha256 "bc37afccdf55de047502b87fe56d537cdf78674ccaec1a401b2d29552d6b2dfc"
  head "https://github.com/relipmoc/skewer.git"
  # doi "10.1186/1471-2105-15-182"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1efd9467a923be12559c55c57d8cf91e2d9054d4141356b91a16fcfb6622f33" => :el_capitan
    sha256 "1a1ed956768778eac2cab76e56c293cbab437822c3e8077e1a5c5c54bbcd4da4" => :yosemite
    sha256 "381f84679b7e898b7dfb9a0f69ba657f53c9d85fc33ceae0d2b193d5311743c7" => :mavericks
    sha256 "01c53596342c659090a5a989a06569e67fd380073cce301452002063ef98e2ea" => :x86_64_linux
  end

  def install
    system "make", "CXX=#{ENV.cxx}", "CXXFLAGS=-c #{ENV.cxxflags}"
    bin.install "skewer"
    doc.install "README.md", "LICENSE"
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/skewer --help 2>&1", 1)
  end
end
