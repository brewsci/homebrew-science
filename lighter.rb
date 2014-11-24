require "formula"

class Lighter < Formula
  homepage "https://github.com/mourisl/Lighter"
  url "https://github.com/mourisl/Lighter/archive/v1.0.3.tar.gz"
  head "https://github.com/mourisl/Lighter.git"
  sha1 "60451effb3b4185f5d2f0a2862dfb9b56e8ffe2c"
  #tag 'bioinformatics'
  #doi '10.1186/s13059-014-0509-9'

  def install
    system "make"
    bin.install "lighter"
    doc.install "README.md", "LICENSE"
  end

  test do
    system "#{bin}/lighter -h"
  end
end
