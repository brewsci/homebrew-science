class Quast < Formula
  homepage "http://bioinf.spbau.ru/en/quast"
  # doi "10.1093/bioinformatics/btt086"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/quast/quast-2.3.tar.gz"
  sha1 "9bf176f852cf1b77f201b15e7d9262ae29cff727"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "e47b24a193b840caaacb7d51b79bd82ee8da4fbd" => :yosemite
    sha1 "2bd608e09c1acff89b02b0ab8e283b9b7cdeb177" => :mavericks
    sha1 "6c9d011cd0449cce589b2046b95dd8b11385f2ab" => :mountain_lion
  end

  if OS.mac? && MacOS.version <= :mountain_lion
    depends_on "homebrew/python/matplotlib"
  else
    # Mavericks and newer include matplotlib
    depends_on "matplotlib" => :python
  end

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../quast.py", "../metaquast.py"
    bin.install_symlink "quast.py" => "quast", "metaquast.py" => "metaquast"
  end

  test do
    system "#{bin}/quast"
    cd prefix do
      system "#{bin}/quast", "--test"
      rm_rf "quast_test_output"
    end
  end
end
