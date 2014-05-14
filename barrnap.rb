require "formula"

class Barrnap < Formula
  homepage "http://www.vicbioinformatics.com/software.barrnap.shtml"
  url "http://www.vicbioinformatics.com/barrnap-0.4.tar.gz"
  sha1 "28e8a039e88867eacaf3c349f79e72b9f3348ddf"
  head "https://github.com/Victorian-Bioinformatics-Consortium/barrnap.git"

  depends_on "hmmer"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/barrnap --version"
  end
end
