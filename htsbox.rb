class Htsbox < Formula
  desc "Experimental tools on top of htslib"
  homepage "https://github.com/lh3/htsbox"
  # tag "bioinformatics"

  url "https://github.com/lh3/htsbox/archive/1b2dee28b52f28afdd14510f551e6aaf658efa8d.tar.gz"
  version "r311"
  sha256 "9a1e8bee4527973d1c4f27203a959380ea266cc23ad7d3a51d530815d0ec6ec4"

  head "https://github.com/lh3/htsbox.git"

  bottle do
    cellar :any
    sha256 "25862df2d67c335b7f6d02f8c3a29f4a0c25280e7fd0e1c216db456451ed825d" => :yosemite
    sha256 "d736c37859db258b1437e7ade182dc4d1a545630a66ba684e3cbea65434d933e" => :mavericks
    sha256 "3a04a5a8efdd6a4175fdc8d40e172db1f0761f6dba5f25dc27c1303590c9c3d3" => :mountain_lion
  end

  depends_on "htslib"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "htsbox"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/htsbox 2>&1", 1)
  end
end
