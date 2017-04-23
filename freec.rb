class Freec < Formula
  desc "Copy number and genotype annotation in whole genome/exome sequencing data"
  homepage "http://bioinfo.curie.fr/projects/freec/"
  url "https://github.com/BoevaLab/FREEC/archive/v10.6.tar.gz"
  sha256 "4e82f64bde5ff6ae4f02337c9fe30370282949b205dfc8d4aae5b789d1dd2838"
  head "https://github.com/BoevaLab/FREEC.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr670"

  bottle do
    cellar :any_skip_relocation
    sha256 "36fbc93543b4f5e4703461b25ed14e099983d4dde3f1e329b0cb911bbbe350a3" => :sierra
    sha256 "3283bcbec7ff79337ea130585a615462714a27aba9bc259167735b2dbd6c0613" => :el_capitan
    sha256 "1a57935e21a4404f234da9b4c8fbd27ed4451f193947c78e0e59764a92066bf0" => :yosemite
    sha256 "206a459a742525ab32a845c395327bbadab9a14140054eb5e4980bea3dcf5f7d" => :x86_64_linux
  end

  def install
    cd "src" do
      system "make"
      bin.install "freec"
    end
    pkgshare.install "scripts", "data"
  end

  test do
    assert_match "FREEC v#{version}", shell_output("#{bin}/freec 2>&1")
  end
end
