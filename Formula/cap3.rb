class Cap3 < Formula
  homepage "http://seq.cs.iastate.edu/cap3.html"
  desc "CAP3: A DNA Sequence Assembly Program"
  # doi "10.1101/gr.9.9.868"
  # tag "bioinformatics"

  if OS.mac?
    url "http://seq.cs.iastate.edu/CAP3/cap3.macosx.intel64.tar"
    sha256 "4b6e8fa6b39147b23ada6add080854ea9fadace9a9c8870a97ac79ff1c75338e"
  elsif OS.linux?
    url "http://seq.cs.iastate.edu/CAP3/cap3.linux.x86_64.tar"
    sha256 "3aff30423e052887925b32f31bdd76764406661f2be3750afbf46341c3d38a06"
  end
  version "2015-02-11"

  bottle do
    cellar :any
    sha256 "61329ff5526879a0320d501ffb4af26c59e49c1566d591367bb64f242a28893d" => :yosemite
    sha256 "9080e7cf4f6b244361b01add77a5498d297c186ca1012b17455a2cdb71d568a8" => :mavericks
    sha256 "c0e10492341a197b49ccd92cdf5eb401f29455e03c6aecda4a8db4f1e95ffeee" => :mountain_lion
    sha256 "e12918e92ecc14cca721c5e1758e6d5b2dd24661555b62905cc5b9cd8266d563" => :x86_64_linux
  end

  def install
    bin.install "cap3", "formcon"
    doc.install %w[README aceform doc example]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/cap3 2>&1", 1)
  end
end
