class Geneid < Formula
  desc "Predict genes in anonymous genomic sequences"
  homepage "http://genome.crg.es/software/geneid/"
  url "ftp://genome.crg.es/pub/software/geneid/geneid_v1.4.4.Jan_13_2011.tar.gz"
  sha256 "8c172eb783a7c2c11a0508bafd60cd63e6698a3961db1478a231acb65d855a2d"
  version "1.4.4"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b6004ab561a4abb8989ff842059c0d69c86b3aa65a496fb2d2ab73f584dfa290" => :el_capitan
    sha256 "8343b87beee45227edcd3f7b523ae84773cc713f73e6e651ccba445cc223160b" => :yosemite
    sha256 "2f9ac83038dc708ec3cb2503e5e7b62c33151206b2996e7f5c82595be435a531" => :mavericks
    sha256 "68c463fb34cfeae9be70115f13e83fb5076c31f22aa818cb1b2f941ace43a78e" => :x86_64_linux
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
