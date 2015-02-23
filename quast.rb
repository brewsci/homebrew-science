class Quast < Formula
  homepage "http://bioinf.spbau.ru/en/quast"
  # doi "10.1093/bioinformatics/btt086"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/quast/quast-2.3.tar.gz"
  sha1 "9bf176f852cf1b77f201b15e7d9262ae29cff727"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    revision 1
    sha1 "d223217a74fb8c58591f820c30008681baef6e26" => :yosemite
    sha1 "6ae5d0394aa9971a3ab77978f92b10fab2cabbe2" => :mavericks
    sha1 "d5b9721b4209dc4fe0826068470e4f6cf90097e8" => :mountain_lion
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
    system "#{bin}/quast"
    cd prefix do
      system "#{bin}/quast", "--test"
      rm_rf "quast_test_output"
    end
  end
end
