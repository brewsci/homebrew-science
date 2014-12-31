class Seqtk < Formula
  homepage "https://github.com/lh3/seqtk"
  #tag "bioinformatics"

  url "https://github.com/lh3/seqtk/archive/08b3625c2a7aae3eca9ab056e1adea52ec22cbef.tar.gz"
  sha1 "7274ebab93caa66d3a75aada784ee5679834d504"
  version "75"

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
    system "#{bin}/seqtk 2>&1 |grep -q seqtk"
  end
end
