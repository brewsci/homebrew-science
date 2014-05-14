require "formula"

class Barrnap < Formula
  homepage "http://www.vicbioinformatics.com/software.barrnap.shtml"
  url "http://www.vicbioinformatics.com/barrnap-0.4.2.tar.gz"
  sha1 "009d82d3f548c13675736b8a6a0aa0d3f5849c64"
  head "https://github.com/Victorian-Bioinformatics-Consortium/barrnap.git"

  depends_on "hmmer"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/barrnap --version"
  end
end
