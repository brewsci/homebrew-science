class Orthofinder < Formula
  desc "Accurate inference of orthologous gene groups made easy"
  homepage "https://github.com/davidemms/OrthoFinder"
  url "https://github.com/davidemms/OrthoFinder/archive/2.1.2.tar.gz"
  sha256 "638f5f5d4983eacf8f0f20887e2ae12ba8e2b7510838edf9a922d8c8f66b4f8e"
  head "https://github.com/davidemms/OrthoFinder.git"
  # doi "10.1186/s13059-015-0721-2"
  # tag "bioinformatics"

  bottle :unneeded

  depends_on "blast"
  depends_on "mcl"
  depends_on "scipy"
  depends_on "fasttree" => :recommended
  depends_on "mafft" => :recommended

  def install
    pkgshare.install "orthofinder/ExampleDataset"
    libexec.install (buildpath/"orthofinder").children
    bin.write_exec_script("#{libexec}/orthofinder.py")
  end

  test do
    system "#{bin}/orthofinder.py", "--help"
  end
end
