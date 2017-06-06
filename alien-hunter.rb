class AlienHunter < Formula
  desc "Identification of Horizontally Acquired DNA"
  homepage "https://www.sanger.ac.uk/science/tools/alien-hunter"
  # doi "10.1093/bioinformatics/btl369"
  # tag "bioinformatics"

  url "ftp://ftp.sanger.ac.uk/pub/resources/software/alien_hunter/alien_hunter.tar.gz"
  version "1.7"
  sha256 "6970a84262b46a6361c829b4510878b70ce0375dd78a19e78bd68ea8b15460e1"

  depends_on :java

  def install
    inreplace "alien_hunter", "`dirname $0`", prefix
    rm_r "CVS"
    prefix.install Dir["*"]
    bin.install_symlink prefix/"alien_hunter"
  end

  test do
    assert_match "HGT", shell_output("#{bin}/alien_hunter 2>&1", 0)
  end
end
