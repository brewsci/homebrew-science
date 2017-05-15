class Topcat < Formula
  desc "Interactive graphical viewer and editor for tabular data"
  homepage "http://www.star.bris.ac.uk/~mbt/topcat/"
  url "http://www.star.bris.ac.uk/~mbt/topcat/topcat-full.jar"
  version "4.4"
  sha256 "debc7a3bb245d4651ef9f5321e620763b11d8524eed8efd3c086a9d2c9f47441"

  def install
    (share+"java").install "topcat-full.jar"
  end

  def caveats
    <<-EOS.undent
      The Java JAR files are installed to
        #{share}/java
    EOS
  end
end
