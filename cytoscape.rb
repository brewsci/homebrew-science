class Cytoscape < Formula
  homepage "http://www.cytoscape.org/"
  # tag "bioinformatics"
  # doi "10.1038/nmeth.2212"
  url "http://chianti.ucsd.edu/cytoscape-3.2.0/cytoscape-3.2.0.tar.gz"
  sha1 "a0bc0832ef986d98bfbe5d9f377f87df0efb1d6d"

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
