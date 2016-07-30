class Orthofinder < Formula
  desc "Accurate inference of orthologous gene groups made easy"
  homepage "https://github.com/davidemms/OrthoFinder"
  url "https://github.com/davidemms/OrthoFinder/archive/0.7.1.tar.gz"
  sha256 "7d406baeb639250c3df9cdb348803e758fa4e65b391749ddc82d96db3f277436"
  head "https://github.com/davidemms/OrthoFinder.git"
  # doi "10.1186/s13059-015-0721-2"
  # tag "bioinformatics"

  depends_on "blast"
  depends_on "mcl"
  depends_on "fasttree" => :recommended
  depends_on "mafft" => :recommended
  depends_on "scipy" => :python

  def install
    bin.install "orthofinder.py", "trees_for_orthogroups.py"
    doc.install "License.md", "README.md", "ExampleDataset"
  end

  test do
    system "#{bin}/orthofinder.py", "--help"
    system "#{bin}/trees_for_orthogroups.py", "--help"
  end
end
