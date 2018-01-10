class Scarpa < Formula
  homepage "http://compbio.cs.toronto.edu/hapsembler/scarpa.html"
  # doi "10.1093/bioinformatics/bts716"
  # tag "bioinformatics"

  url "http://compbio.cs.toronto.edu/hapsembler/scarpa-0.241.tar.gz"
  sha256 "a5e71d63b8c828d4bd0ee081d1c5250ce25ffa52b4b2a8759d2a75ce2863d558"

  bottle do
    cellar :any
    sha256 "c8eca0370427c99c07735f9bf4d2db7149aa17cf221ee90f66b4fcc9c5f1a3f3" => :yosemite
    sha256 "8b1d2ffaa4981728042baac900544b43f2a384520d7a508da9c8242a21fa2bd9" => :mavericks
    sha256 "aa03bd7b53f6101dedb8a79bc053a8267e9bf49967d537ae9bce50ecb1323134" => :mountain_lion
    sha256 "0a4011e9cd1768640b8dec14542bd3f12ce42401765fdb725d980d23777350f7" => :x86_64_linux
  end

  depends_on "lp_solve"

  def install
    rm Dir["liblpsolve55.*"]
    inreplace "makefile", "liblpsolve55.a", "-llpsolve55"
    system "make"
    bin.install "bin/scarpa"
    doc.install "SCARPA.README"
  end

  test do
    system "#{bin}/scarpa", "--version"
  end
end
