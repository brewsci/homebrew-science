class Bbtools < Formula
  desc "suite of Brian Bushnell's tools for manipulating reads"
  homepage "http://bbmap.sourceforge.net/"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/bbmap/BBMap_35.85.tar.gz"
  sha256 "037b3f7793e428ba016e79b01eab378da8ca885ebac660df295d65f34dba38bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc6caa710db30124f9f3bc829b90e961fead12e514c6c85cf5eb02155d39e289" => :el_capitan
    sha256 "cefdee5a7bff7cbc25583a423aeed79bd78871093d8dc796513b324c95d0b142" => :yosemite
    sha256 "64937d61419187c1ee007a6d96deec813984ecbeec67d6088f9f34d1f5459d7b" => :mavericks
    sha256 "c248889cd98f335fe7e251635ce86763e9b9fa77644f5c67e482fb36208f9bf0" => :x86_64_linux
  end

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
