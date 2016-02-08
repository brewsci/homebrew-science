class Quast < Formula
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://bioinf.spbau.ru/en/quast"
  # doi "10.1093/bioinformatics/btt086"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/quast/quast-3.2.tar.gz"
  sha256 "e1534824fc185679f0fa9c03846fbcf34b6a20466a6ec0110cf74f14c6380c02"

  bottle do
    cellar :any
    sha256 "31424b63c4575c86f8a8738e344f5de2db54dc825c48768ca05eba203f739cb0" => :yosemite
    sha256 "e7059ac774256316780e30786c01f62848b47f084c235414d22efbdc3c917598" => :mavericks
    sha256 "01b2f6d165f44f5883c6a149ae5761902b22e7fc5e1c9ad95928899a142968e4" => :mountain_lion
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
  end

  test do
    system "#{bin}/quast", "--test"
  end
end
