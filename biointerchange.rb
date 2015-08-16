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

  def install
    bin.install "biointerchange"
    doc.install "license.txt"
  end

  test do
    assert_match "#{version}", shell_output("biointerchange -v")
  end
end
