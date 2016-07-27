class Quast < Formula
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://bioinf.spbau.ru/en/quast"
  # doi "10.1093/bioinformatics/btt086"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/quast/quast-4.2.tar.gz"
  sha256 "fbaa1b5fe0cbbcbbedaafebce5a922250ad7b916fc7538b73cd16c3d70226db3"

  bottle do
    cellar :any_skip_relocation
    sha256 "b49c53be3c39c9fbc24082ad29402ecb451501f469c533d6b5838e45d73e2340" => :el_capitan
    sha256 "d43ba8fed47a052605a25c52f893401256043b4b38a2ba7fd5f67ef12636ab15" => :yosemite
    sha256 "b49d73e6874c29fd123b8294fe909cb46d062c5d72d7e4bf7f52f57ab534b145" => :mavericks
    sha256 "82f8226084ea64acdd28bc20857b6363398592a2d5bdfcbc69e2016a95164096" => :x86_64_linux
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
