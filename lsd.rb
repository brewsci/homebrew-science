class Lsd < Formula
  desc "Least-Squares for estimating Dates from phylogenies"
  homepage "https://github.com/tothuhien/lsd-0.3beta"
  bottle do
    cellar :any_skip_relocation
    sha256 "79d386d8cc6098d384db82e3f429f47cb72e40d1ed61b96ccc9b594f2ea59fca" => :el_capitan
    sha256 "5e96e65e0ba2d7e186b426d0c07ae23001c900070e59362426166d10924f9825" => :yosemite
    sha256 "fc8f99290db0e29e2686f052a0d345fa4893a172b54a0bf294a10741a4943b79" => :mavericks
    sha256 "b5d84d48a1f2724edeee5cdea68bb2bedb9a4d7f65399a0b374e0c76e380859e" => :x86_64_linux
  end

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
