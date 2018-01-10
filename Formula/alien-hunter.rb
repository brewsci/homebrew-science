class AlienHunter < Formula
  desc "Identification of Horizontally Acquired DNA"
  homepage "https://www.sanger.ac.uk/science/tools/alien-hunter"
  bottle do
    cellar :any_skip_relocation
    sha256 "d2bb9e4c3ca641bbdef8233e69eb5b36effd844cdeff6946dbc3dedd58e9632e" => :sierra
    sha256 "7095286b88c0b90a47d675ba2704bddc6092bb5bc9a8c43c1c8b576619242187" => :el_capitan
    sha256 "7095286b88c0b90a47d675ba2704bddc6092bb5bc9a8c43c1c8b576619242187" => :yosemite
    sha256 "858ec6cc4f838f7e2d52a7f7facf1901eaf1acd539dcf52b02a8604d92dc47fe" => :x86_64_linux
  end

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
