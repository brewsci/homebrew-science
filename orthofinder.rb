class Orthofinder < Formula
  desc "Accurate inference of orthologous gene groups made easy"
  homepage "https://github.com/davidemms/OrthoFinder"
  url "https://github.com/davidemms/OrthoFinder/archive/1.1.10.tar.gz"
  sha256 "9059efbb980c153237ae227c5c453d17f4ea9ce4c308ab8d4e112cd9da7d3c42"
  head "https://github.com/davidemms/OrthoFinder.git"
  # doi "10.1186/s13059-015-0721-2"
  # tag "bioinformatics"

  bottle :unneeded

  depends_on "blast"
  depends_on "mcl"
  depends_on "fasttree" => :recommended
  depends_on "mafft" => :recommended
  depends_on "scipy" => :python

  def install
    pkgshare.install "orthofinder/ExampleDataset"
    libexec.install (buildpath/"orthofinder").children
    bin.write_exec_script("#{libexec}/orthofinder.py")
  end

  test do
    system "#{bin}/orthofinder.py", "--help"
  end
end
