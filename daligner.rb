require "formula"

class Daligner < Formula
  homepage "https://github.com/thegenemyers/DALIGNER"
  head "https://github.com/thegenemyers/DALIGNER.git"

  version "2014-07-10"
  url "https://github.com/thegenemyers/DALIGNER/archive/52dc8b0.tar.gz"
  sha1 "a8a43c43c09730990e804a212804b35ef899bd57"

  def install
    # Fix clang: error: cannot specify -o when generating multiple output files
    inreplace "Makefile", " DB.h", ""

    system "make"
    bin.install %w[daligner HPCdaligner
      LAsort LAmerge LAshow LAsplit LAcat LAcheck]
  end

  test do
    system "#{bin}/daligner 2>&1 |grep daligner"
  end
end
