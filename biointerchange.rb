class Biointerchange < Formula
  desc "Scaling and integrating genomics data."
  homepage "https://www.codamono.com"
  # tag "bioinformatics"

  if OS.mac?
    version "2.0.3+100"
    url "https://www.codamono.com/brew/osx-10-10/biointerchange-2.0.3+100.tar.gz"
    sha256 "0bc61490b086b40c56132c4e405c7bf5e9fca28782bb0ee73cd88f4563896b32"
  elsif OS.linux?
    version "2.0.3+100"
    url "https://www.codamono.com/brew/debian-8-amd64/biointerchange-2.0.3+100.tar.gz"
    sha256 "4f1687adfb1f44dd094edd6a1f451cd6c25fd9f82f84b5457b4c0a3be43b5e5e"
  end

  def install
    bin.install "biointerchange"
    doc.install "license.txt"
  end

  test do
    assert_match "#{version}", shell_output("biointerchange -v")
  end
end
