class Graphlan < Formula
  desc "Render circular taxonomic and phylogenetic trees"
  homepage "https://bitbucket.org/nsegata/graphlan/wiki/Home"
  # tag "bioinformatics"

  url "https://hg@bitbucket.org/nsegata/graphlan", :using => :hg, :tag => "1.0"

  depends_on LanguageModuleRequirement.new :python, "biopython", "Bio"
  depends_on "matplotlib" => :python

  def install
    prefix.install Dir["*.py"], "src", "pyphlan"
    bin.install_symlink "../graphlan.py" => "graphlan"
    bin.install_symlink "../graphlan_annotate.py" => "graphlan_annotate"
    pkgshare.install "examples", "export2graphlan"
    doc.install "license.txt", "readme.txt"
  end

  test do
    dir = pkgshare/"examples/simple"
    xml = "out.xml"
    png = "out.png"
    system "graphlan_annotate", "#{dir}/core_genes.txt", xml, "--annot", "#{dir}/annot.txt"
    assert File.exist?(xml)
    system "graphlan", xml, png, "--dpi", "150", "--size", "4", "--pad", "0.2"
    assert File.exist?(png)
  end
end
