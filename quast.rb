class Quast < Formula
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://cab.spbu.ru/software/quast/"
  # doi "10.1093/bioinformatics/btt086", "10.1093/bioinformatics/btv697", "10.1093/bioinformatics/btw379"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/quast/quast-4.5.tar.gz"
  sha256 "6c6e0b108d7d3f47d42a2205e8a95ed07a240829ed0980e5058b20e44bc666bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d3a3fc7e4840c09b9a642ae72f5435931c975bdeb5b4a959c41d287f18599fd" => :sierra
    sha256 "0804992f335212327fa1fc9674bef2ccffb294442270f12197109e4fdd6bc726" => :el_capitan
    sha256 "c29b8da6a51e654627b9df896ac36cf6fd42950cb7a4256d8b093ae3497c5faf" => :yosemite
    sha256 "f4b54ea0477fd1d2793ec5deb824ae117e75466f1218fc4b922e77e1cbcd03d9" => :x86_64_linux
  end

  if OS.mac? && MacOS.version <= :mountain_lion
    depends_on "matplotlib"
  else
    # Mavericks and newer include matplotlib
    depends_on "matplotlib" => :python
  end
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
