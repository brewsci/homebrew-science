class Quast < Formula
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://cab.spbu.ru/software/quast/"
  # doi "10.1093/bioinformatics/btt086", "10.1093/bioinformatics/btv697", "10.1093/bioinformatics/btw379"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/quast/quast-4.6.1.tar.gz"
  sha256 "7ace5bebebe9d2a70ad45e5339f998bd651c1c6b9025f7a3b51f44c87ea5bae0"

  bottle do
    sha256 "b92333c9a18282bd3f9101493f5551e70a943d1674663731c27cc7d675274962" => :high_sierra
    sha256 "70fdf8ca6c98696ea88abe6dd776ea553b880e4c4bdb69f0c7d3bfdb0a758f8a" => :sierra
    sha256 "0716a92532645e720c75be385ce0989137e2b136dc23a7417eb459f8037dbec7" => :el_capitan
    sha256 "bbd22abb6a20e42b2d9a3889649f5996f9cc0dd32d6c53266762924d4c12d83c" => :x86_64_linux
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
