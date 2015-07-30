class Biointerchange < Formula
  desc "BioInterchange: a tool for scaling and integrating genomics data"
  homepage "https://www.codamono.com"
  # tag "bioinformatics"

  if OS.mac?
    version "2.0.1+74"
    url "https://www.codamono.com/brew/osx-10-10/biointerchange-2.0.1+74.tar.gz"
    sha256 "ed1864b13aaf23518d32867683bfcc9bc8c15902c12b549433832e83b43926a6"
  elsif OS.linux?
    version "2.0.1+75"
    url "https://www.codamono.com/brew/debian-8-amd64/biointerchange-2.0.1+75.tar.gz"
    sha256 "a8a9bff83d3fe83ac8151b129a4b45584047f62d2e1a34da55e6b4810bdcaa83"
  end

  def install
    bin.install "biointerchange"
    doc.install "license.txt"
  end

  test do
    assert_match "#{version}", shell_output("biointerchange -v")
  end
end
