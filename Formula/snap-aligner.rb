class SnapAligner < Formula
  homepage "https://snap.cs.berkeley.edu/"
  # doi "arXiv:1111.5572v1"
  # tag "bioinformatics"

  url "https://github.com/amplab/snap/archive/v0.15.tar.gz"
  sha256 "bea0174c8d01907023494d7ffd2a6dab9c38d248cfe4d3c26feedf9d5becce9a"
  head "https://github.com/amplab/snap.git"

  bottle do
    cellar :any
    sha256 "bdb7de8593f0f83ace9e11423cf87636be7dd183fdcbf9e39829f444aa1c4a63" => :yosemite
    sha256 "20aea132585381f4594d1f825eaf10daa162155d2b0f2b5c19d9623561ab8026" => :mavericks
    sha256 "de30d5c47495d05ba11c32114adbbf21fdab5bea9a1f80ac281e43579a2a3fcf" => :mountain_lion
    sha256 "eebca15ab841a3344e87850d03ff4cf315039a8cc6d790d39859b32df6ed3bba" => :x86_64_linux
  end

  conflicts_with "snap", :because => "both install bin/snap"

  def install
    system "make"
    bin.install "snap"
    doc.install "LICENSE", "README.md"
  end

  test do
    system "#{bin}/snap |grep SNAP"
  end
end
