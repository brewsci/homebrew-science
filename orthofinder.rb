class Orthofinder < Formula
  desc "Accurate inference of orthologous gene groups made easy"
  homepage "https://github.com/davidemms/OrthoFinder"
  url "https://github.com/davidemms/OrthoFinder/archive/1.1.4.tar.gz"
  sha256 "5a3b492b17a1089850e98a92594dc56a1304b963b826a9040f179d5b729fb574"
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
