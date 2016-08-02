class Orthofinder < Formula
  desc "Accurate inference of orthologous gene groups made easy"
  homepage "https://github.com/davidemms/OrthoFinder"
  url "https://github.com/davidemms/OrthoFinder/archive/0.7.1.tar.gz"
  sha256 "7d406baeb639250c3df9cdb348803e758fa4e65b391749ddc82d96db3f277436"
  head "https://github.com/davidemms/OrthoFinder.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "50c3ae5fa80e3c046667cfdfa234a62a007bec5eb61dbbea2681a40d660d060e" => :el_capitan
    sha256 "b58ec2624b0c6dd992f59b1d44d45f413b6c066cd2231cb9eacea6a15e51940f" => :yosemite
    sha256 "dd6335bb6e072071edc1e3bd4f9e3b115736f27f3ffd631e804db4d477caa6fc" => :mavericks
  end

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
