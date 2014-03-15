require "formula"

class Repeatscout < Formula
  homepage "http://bix.ucsd.edu/repeatscout/"
  url "http://repeatscout.bioprojects.org/RepeatScout-1.0.5.tar.gz"
  sha1 "507fe8813de341244c5380836ddcf4257bb46c81"

  def install
    system "make"
    prefix.rmdir
    system *%W[make install INSTDIR=#{prefix}]
    bin.install_symlink "../RepeatScout"
  end

  test do
    system "#{bin}/RepeatScout 2>&1 |grep RepeatScout"
  end
end
