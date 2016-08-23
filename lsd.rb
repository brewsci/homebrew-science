class Lsd < Formula
  desc "Least-Squares for estimating Dates from phylogenies"
  homepage "https://github.com/tothuhien/lsd-0.3beta"
  # doi "10.1093/sysbio/syv068"
  # tag "bioinformatics"

  url "https://github.com/tothuhien/lsd-0.3beta/archive/v0.3-beta.tar.gz"
  version "0.3b"
  sha256 "47a40730c53d82cbdae5466c061888e1f75bbcf52cbbfeb32b17d97a3b8f0b4a"

  needs :cxx11

  def install
    rm_r "bin"
    system "make", "-C", "src"
    bin.install "src/lsd"
    pkgshare.install "examples"
    doc.install "NEWS", "README.md"
  end

  test do
    assert_match "RATE1", shell_output("#{bin}/lsd -h 2>&1", 0)
  end
end
