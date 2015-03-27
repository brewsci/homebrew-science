class Clark < Formula
  homepage "http://clark.cs.ucr.edu/"
  # tag "bioinformatics"
  # doi "10.1186/s12864-015-1419-2"

  url "http://clark.cs.ucr.edu/Download/CLARKV1.1.tar.gz"
  sha256 "9e1e2bc3eee3260925508a2f0b835199b681e6b019a7b9dc54c30bd3766b5ce5"

  needs :openmp

  def install
    system "sh", "make.sh"
    bin.install "CLARK"
    bin.install "CLARK-l"
    doc.install "README.txt", "LICENSE_GNU_GPL.txt"
  end

  test do
    assert_match "k-spectrum", shell_output("CLARK 2>&1", 255)
  end
end
