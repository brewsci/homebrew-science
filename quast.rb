class Quast < Formula
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://cab.spbu.ru/software/quast/"
  # doi "10.1093/bioinformatics/btt086", "10.1093/bioinformatics/btv697", "10.1093/bioinformatics/btw379"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/quast/quast-4.6.0.tar.gz"
  sha256 "fcb5ac34c7fd71ceedd75fa8da6136e7ef66cdcc9a87216b7ea11a2012f61f56"

  bottle do
    sha256 "67b4a3574978a0ba1436462648ff0897bb833948a4322a542c35b8ccd7747d47" => :sierra
    sha256 "c05c9eb8135431aed74343b77a121622bf806d017c0a1695a5a2ee73fc0dca4c" => :el_capitan
    sha256 "e8119dd0f298fc9fb44960fc8563e4235b45bef98afee23c92262d2945f4345c" => :x86_64_linux
  end

  depends_on "matplotlib"
  depends_on "e-mem"

  def install
    # removing precompiled E-MEM binary causing troubles with brew audit
    rm "quast_libs/MUMmer/e-mem-osx"
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
