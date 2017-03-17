class Quast < Formula
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://cab.spbu.ru/software/quast/"
  # doi "10.1093/bioinformatics/btt086", "10.1093/bioinformatics/btv697", "10.1093/bioinformatics/btw379"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/quast/quast-4.5.tar.gz"
  sha256 "6c6e0b108d7d3f47d42a2205e8a95ed07a240829ed0980e5058b20e44bc666bb"

  bottle do
    sha256 "b0e39c8e7a45032b00c87110e618def5ab305cebe3b3fbf9bc44b080fb09e972" => :sierra
    sha256 "33c358b0970717d2410dc41b64fb5dd3e141e7f3f87893ceda36c750cba78bf0" => :el_capitan
    sha256 "38a0923ae4806858a7099ba64e1f8d2d7100ec13ee703c0f34addf2328db93b6" => :yosemite
    sha256 "b7d7548f11945ad2ca7484b9a31552c319cf6c027d7dc825f351a7f3960e725d" => :x86_64_linux
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
