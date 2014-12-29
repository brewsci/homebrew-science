require "formula"

class Kmergenie < Formula
  homepage "http://kmergenie.bx.psu.edu/"
  #doi "10.1093/bioinformatics/btt310"
  #tag "bioinformatics"

  url "http://kmergenie.bx.psu.edu/kmergenie-1.6476.tar.gz"
  sha1 "744ccd0f033af6be15fc9f6edfa31af08b316e40"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "8e1536217c14b7a76a77a352ef0b686f21f2abf2" => :yosemite
    sha1 "36856e81e9824d586b670db1afe6d46b57848c9a" => :mavericks
    sha1 "7712fa5cacb912203753cae0b2b5154d14d1cd92" => :mountain_lion
  end

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
