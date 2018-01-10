class Biointerchange < Formula
  desc "Scaling and integrating genomics data"
  homepage "https://www.codamono.com/biointerchange/"
  # tag "bioinformatics"

  if OS.mac?
    version "2.0.4+105"
    url "https://www.codamono.com/brew/osx-10-10/biointerchange-2.0.4+105.tar.gz"
    sha256 "731418a77dd8cbf4f672828b303a3f930fe7f9c6aeb61021e98022c674a3ed88"
  elsif OS.linux?
    version "2.0.4+105"
    url "https://www.codamono.com/brew/debian-8-amd64/biointerchange-2.0.4+105.tar.gz"
    sha256 "7629eb6a6be98eb0083ea4347b3893a05769c385f43f5d2805576eb967589431"
  end

  bottle :unneeded

  def install
    bin.install "biointerchange"
    doc.install "license.txt"
  end

  test do
    assert_match version.to_s, shell_output("biointerchange -v")
  end
end
