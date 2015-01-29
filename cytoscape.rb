class Cytoscape < Formula
  homepage "http://www.cytoscape.org/"
  # tag "bioinformatics"
  # doi "10.1038/nmeth.2212"
  url "http://chianti.ucsd.edu/cytoscape-3.2.0/cytoscape-3.2.0.tar.gz"
  sha1 "a0bc0832ef986d98bfbe5d9f377f87df0efb1d6d"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "c0e15358a96ac2b9504b676c6353fd0e583a5877" => :yosemite
    sha1 "62659dcc978f91da8ea71b2c65eea349a23103a9" => :mavericks
    sha1 "b30e494d4dd8b66c77cddf7810c447910db884a0" => :mountain_lion
  end

  depends_on :java => "1.7"

  def install
    inreplace "cytoscape.sh", "$script_path", prefix
    prefix.install %W[cytoscape.sh gen_vmoptions.sh framework sampleData]
    bin.install_symlink prefix/"cytoscape.sh" => "cytoscape"
  end

  test do
    system "#{bin}/cytoscape", "--version"
  end
end
