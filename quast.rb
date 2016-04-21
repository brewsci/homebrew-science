class Quast < Formula
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://bioinf.spbau.ru/en/quast"
  # doi "10.1093/bioinformatics/btt086"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/quast/quast-4.0.tar.gz"
  sha256 "f8e3b631131a6f133c9973c57e2d615be9b7f8e8ae05f76560b7c2a01ee97ed5"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f4cedcf48ba8849a765d9d199b5f2e68b4dc480438b728a7b3e61798dca7a53" => :el_capitan
    sha256 "ecbea59dde891b455f1a73c1be3cc3a4190c4a2c89667a2e03f398a223689a6e" => :yosemite
    sha256 "10af4a838eff2dbc7b706b078d97e8292d2a1449fdea5687e97cf045fa1573d0" => :mavericks
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
