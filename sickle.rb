class Sickle < Formula
  homepage "https://github.com/najoshi/sickle"
  # tag "bioinformatics

  url "https://github.com/najoshi/sickle/archive/v1.33.tar.gz"
  sha1 "593274fb7e12a52c9086dff69623aedca1799a5c"
  head "https://github.com/najoshi/sickle.git"

  bottle do
    cellar :any
    sha1 "ffaaf08bc55e6d79972208a64c44c125f60a6539" => :yosemite
    sha1 "8d94809d5e0068715169dd71c2681608a5ff82b8" => :mavericks
    sha1 "9f02ace513d34ea9a75a830fc9e1d3e55a8a300a" => :mountain_lion
  end

  def install
    system "make"
    bin.install "sickle"
    doc.install "README.md"
  end

  test do
    system "#{bin}/sickle", "--version"
  end
end
