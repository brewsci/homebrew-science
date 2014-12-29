require "formula"

class Kmergenie < Formula
  homepage "http://kmergenie.bx.psu.edu/"
  #doi "10.1093/bioinformatics/btt310"
  #tag "bioinformatics"

  url "http://kmergenie.bx.psu.edu/kmergenie-1.6476.tar.gz"
  sha1 "744ccd0f033af6be15fc9f6edfa31af08b316e40"

  depends_on "r"

  def install
    ENV.deparallelize
    system "make"
    libexec.install "kmergenie", "specialk",
      "scripts", "third_party"
    bin.install_symlink "../libexec/kmergenie"
    doc.install "CHANGELOG", "LICENSE", "README"
  end

  test do
    system "#{bin}/kmergenie 2>&1 |grep -q kmergenie"
    system "#{libexec}/specialk"
  end
end
