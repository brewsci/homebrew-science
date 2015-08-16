class Biointerchange < Formula
  desc "Scaling and integrating genomics data."
  homepage "https://www.codamono.com"

  # tag "bioinformatics"

  if OS.mac?
    version "2.0.2+83"
    url "https://www.codamono.com/brew/osx-10-10/biointerchange-2.0.2+83.tar.gz"
    sha256 "5559366bda2141fef951b770ec975d493871ab120173861f80a24734caaee617"
  elsif OS.linux?
    version "2.0.2+84"
    url "https://www.codamono.com/brew/debian-8-amd64/biointerchange-2.0.2+84.tar.gz"
    sha256 "05a317da8c11817b9a4ad6288daabb43d7ca8403f6636dc3037bfc70b83482f9"
  end

  bottle do
    cellar :any
    sha256 "f99e547e7b61db910a21ba5a7d7b0cb4c9691cddda7107cf413b63afa2190488" => :yosemite
    sha256 "0a2d558c1b3c3be8b823d988c14ab74125f13cb61fd13ca1f96d0aa118ed3ff4" => :mavericks
    sha256 "3153e9ad2002e07f47749f238eaa43a928104bc832afe9e27a4e7ca2e2440f5d" => :mountain_lion
  end

  def install
    bin.install "biointerchange"
    doc.install "license.txt"
  end

  test do
    assert_match "#{version}", shell_output("biointerchange -v")
  end
end
