class Clark < Formula
  homepage "http://clark.cs.ucr.edu/"
  # tag "bioinformatics"
  # doi "10.1186/s12864-015-1419-2"

  url "http://clark.cs.ucr.edu/Download/CLARKV1.1.2.tar.gz"
  sha256 "d97936a6c3c9215f659296a665c662de3f9406dcc957f8f58b313edd2c52f371"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "a0f1ca3b707728175ca5c3774ca3c6ea55d4455f44ca36705b5fa2f60b11a53b" => :yosemite
    sha256 "1e34d4ff84565b78abf776ca99c3384b0349bb4f5b48f493821e6760beacac26" => :mavericks
    sha256 "3bc269e1bc75327c298c1f0b6d21741f9895e3755405d65b7352eba1b8547f3e" => :mountain_lion
  end

  needs :openmp

  def install
    system "sh", "install.sh"
    bin.install Dir["exe/*"]
    doc.install "README.txt", "LICENSE_GNU_GPL.txt"
  end

  test do
    assert_match "k-spectrum", shell_output("CLARK 2>&1", 255)
  end
end
