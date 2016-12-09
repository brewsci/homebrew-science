class Clark < Formula
  desc "Fast, accurate and versatile kmer based classification system"
  homepage "http://clark.cs.ucr.edu/"
  # tag "bioinformatics"
  # doi "10.1186/s12864-015-1419-2"

  url "http://clark.cs.ucr.edu/Download/CLARKV1.2.3.tar.gz"
  sha256 "3223daa518a3f5c9f08af6f1a8cca669286672f87197c0c7f2e03504c44b37da"

  bottle do
    cellar :any
    sha256 "1ef50d25121c19b6567f3e5112897a08887189672bf408abeb24979fdbd061b5" => :el_capitan
    sha256 "361ed1106de564e044f96ce1ca82dd894c684ddf7ff58e417533cf567d71fa14" => :yosemite
    sha256 "52acdda74cbcec8a4815d998136784d8769c7c1e7efc7eeb2eab8a44552cbf98" => :mavericks
    sha256 "c7a4f65621a89f894109a50dda5c9614e64808fc30e6d449b8831f44a3be96bf" => :x86_64_linux
  end

  needs :openmp

  def install
    system "sh", "install.sh"
    bin.install Dir["exe/*"]
    doc.install "README.txt", "LICENSE_GNU_GPL.txt", "CHANGELOG"
    pkgshare.install Dir["*.sh"]
  end

  def caveats
    <<-EOS.undent
    Additional helper scripts are installed in #{pkgshare}
    EOS
  end

  test do
    assert_match "k-spectrum", shell_output("#{bin}/CLARK 2>&1", 255)
  end
end
