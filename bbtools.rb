class Bbtools < Formula
  desc "suite of Brian Bushnell's tools for manipulating reads"
  homepage "http://bbmap.sourceforge.net/"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/bbmap/BBMap_35.85.tar.gz"
  sha256 "037b3f7793e428ba016e79b01eab378da8ca885ebac660df295d65f34dba38bc"

  depends_on :java
  depends_on "pigz" => :optional

  def install
    bin.install Dir["*.sh"]
    doc.install %w[license.txt README.md docs/changelog.txt docs/Legal.txt docs/readme.txt docs/ToolDescriptions.txt]
  end

  test do
    system "#{bin}/bbmap.sh 2>&1 | grep -q 'bbushnell@lbl.gov'"
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1", 0)
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1", 0)
  end
end
