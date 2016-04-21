class Quast < Formula
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://bioinf.spbau.ru/en/quast"
  # doi "10.1093/bioinformatics/btt086"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/quast/quast-4.0.tar.gz"
  sha256 "f8e3b631131a6f133c9973c57e2d615be9b7f8e8ae05f76560b7c2a01ee97ed5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b49c53be3c39c9fbc24082ad29402ecb451501f469c533d6b5838e45d73e2340" => :el_capitan
    sha256 "d43ba8fed47a052605a25c52f893401256043b4b38a2ba7fd5f67ef12636ab15" => :yosemite
    sha256 "b49d73e6874c29fd123b8294fe909cb46d062c5d72d7e4bf7f52f57ab534b145" => :mavericks
  end

  if OS.mac? && MacOS.version <= :mountain_lion
    depends_on "homebrew/python/matplotlib"
  else
    # Mavericks and newer include matplotlib
    depends_on "matplotlib" => :python
  end

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../quast.py", "../metaquast.py",
      "quast.py" => "quast", "metaquast.py" => "metaquast"
    # Compile MUMmer, so that `brew test quast` does not fail.
    system "#{bin}/quast", "--test"
  end

  test do
    system "#{bin}/quast", "--test"
  end
end
