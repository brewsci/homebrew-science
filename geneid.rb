class Geneid < Formula
  homepage "http://genome.crg.es/software/geneid/"
  url "ftp://genome.crg.es/pub/software/geneid/geneid_v1.4.4.Jan_13_2011.tar.gz"
  sha256 "8c172eb783a7c2c11a0508bafd60cd63e6698a3961db1478a231acb65d855a2d"
  version "1.4.4"

  bottle do
    cellar :any
    sha256 "982ef7790b96cd276aabf6561393ef0ae0de86685dbaa42c3a09217d99ca290e" => :yosemite
    sha256 "5d9f818ae3a90c770725ab4736e28999b799b5456d3f6ffa1372c7e35a90c0a5" => :mavericks
    sha256 "de8f654e04181ce0764c3aeff647025e212f522c4478282de71e9d10019f8d43" => :mountain_lion
  end

  def install
    system "make"
    bin.install Dir["bin/*"]
    doc.install "README", *Dir["docs/*"]
    pkgshare.install Dir["param/*.param"]
  end

  def caveats; <<-EOS.undent
    The parameter files are installed in
      #{HOMEBREW_PREFIX}/share/geneid
    EOS
  end

  test do
    system "geneid", "-h"
  end
end
