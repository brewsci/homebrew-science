class Topcat < Formula
  homepage "http://www.star.bris.ac.uk/~mbt/topcat/"
  url "https://downloads.sourceforge.net/project/hongpublicfiles/topcat/topcat-4.0-1.tar.gz"
  sha256 "fbd1fbc46c8f5ae8036251367debd6d228d0b69084578d08bf1deff7818be1b5"

  def install
    bin.install "topcat"
    (share+"java").install "topcat-full.jar"
  end

  def caveats
    <<-EOS.undent
      The Java JAR files are installed to
        #{share}/java
    EOS
  end
end
