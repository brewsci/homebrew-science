class Barrnap < Formula
  homepage "http://www.vicbioinformatics.com/software.barrnap.shtml"
  url "http://www.vicbioinformatics.com/barrnap-0.5.tar.gz"
  sha1 "eaed1d131e6b5ba29d41b685c8b5c15acfa3325d"
  head "https://github.com/Victorian-Bioinformatics-Consortium/barrnap.git"

  depends_on "hmmer"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/barrnap", "--version"
  end
end
