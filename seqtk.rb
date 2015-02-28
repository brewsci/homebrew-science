class Seqtk < Formula
  homepage "https://github.com/lh3/seqtk"
  # tag "bioinformatics"

  url "https://github.com/lh3/seqtk/archive/5b8ebb23e9a81466c901a46d089f29c4a1cecfa5.tar.gz"
  version "77"
  sha1 "9c50cc5aceca0450a0cf9cf854c2bad7ebde5a1d"

  head "https://github.com/lh3/seqtk.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "0f57d5741e5cbc781b23d18dc3d5c5611e3e4b2e" => :yosemite
    sha1 "ae24c7991ab1f41674df5d8e5628b47548b776d5" => :mavericks
    sha1 "248bd05dbad49ff4ca9421f5df0089f8134b7984" => :mountain_lion
  end

  def install
    system "make"
    bin.install "seqtk"
    doc.install "README.md"
  end

  test do
    assert_match "seqtk", shell_output("#{bin}/seqtk 2>&1", 1)
  end
end
