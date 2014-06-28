require "formula"

class Galfit < Formula
  homepage "http://users.obs.carnegiescience.edu/peng/work/galfit/galfit.html"
  version "3.0.5"

  depends_on :macos => :leopard

  if MacOS.version == :mavericks
    url "http://users.obs.carnegiescience.edu/peng/work/galfit/galfit3-mavericks.tar.gz"
    sha1 "2cf6fad043efd509b71596712e4f0605ba5622db"
  else
    url "http://users.obs.carnegiescience.edu/peng/work/galfit/galfit3-leopard+.tar.gz"
    sha1 "9a79a80c18540dfe3aa31461487133f84814191a"
  end

  resource "example" do
    url "http://users.obs.carnegiescience.edu/peng/work/galfit/galfit-ex.tar.gz"
    sha1 "e81a292b56c92c6591df4ad053157acd12e0185a"
  end

  def install
    bin.install "galfit"
    (share/"galfit").install resource("example")
  end

  def caveats; <<-EOS.undent
    The documentation and examples are installed to
    #{HOMEBREW_PREFIX}/share/galfit
    EOS
  end

  test do
    cp Dir[share/"galfit/EXAMPLE/*"], testpath
    system "galfit", "galfit.feedme"
  end
end
