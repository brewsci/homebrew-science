class Barrnap < Formula
  homepage "http://www.vicbioinformatics.com/software.barrnap.shtml"
  url "http://www.vicbioinformatics.com/barrnap-0.5.tar.gz"
  sha1 "eaed1d131e6b5ba29d41b685c8b5c15acfa3325d"
  head "https://github.com/Victorian-Bioinformatics-Consortium/barrnap.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "62e01fed459ed2730d05a40ef04f95961f87f7f8" => :yosemite
    sha1 "bb43599e3ba3facc77a888a0403214afed5e0f5e" => :mavericks
    sha1 "81e26c00aeec754174d2825c406207dc14afbc72" => :mountain_lion
  end

  depends_on "hmmer"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/barrnap", "--version"
  end
end
