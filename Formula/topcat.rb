class Topcat < Formula
  desc "Interactive graphical viewer and editor for tabular data"
  homepage "http://www.star.bris.ac.uk/~mbt/topcat/"
  url "http://www.star.bris.ac.uk/~mbt/topcat/topcat-full.jar"
  version "4.4"
  sha256 "debc7a3bb245d4651ef9f5321e620763b11d8524eed8efd3c086a9d2c9f47441"

  bottle do
    cellar :any_skip_relocation
    sha256 "f93af9fc7e095325b815be10eda702dfddc9e1f263ce6074b8c82c388bbcd2e8" => :sierra
    sha256 "9523448a70b5b0ce08d679a067cfc4ea57ff1001a4c60b7fb2bb018a12d2c99e" => :el_capitan
    sha256 "9523448a70b5b0ce08d679a067cfc4ea57ff1001a4c60b7fb2bb018a12d2c99e" => :yosemite
    sha256 "ae3ed505432809d5b274f5bdf7d2498dd33e164b101412ea8a9480a288144b5a" => :x86_64_linux
  end

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
