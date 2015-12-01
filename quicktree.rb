class Quicktree < Formula
  url "ftp://ftp.sanger.ac.uk/pub/resources/software/quicktree/quicktree.tar.gz"
  version "1.1"
  homepage "http://www.sanger.ac.uk/resources/software/quicktree/"
  sha256 "3b5986a8d7b8e59ad5cdc30bd7c7d91431909c25230e8fed13494f21337da6ef"

  def install
    system "make"
    bin.install "bin/quicktree"
  end
end
