class Lighter < Formula
  desc "Fast and memory-efficient sequencing error corrector"
  homepage "https://github.com/mourisl/Lighter"
  # tag 'bioinformatics'
  # doi '10.1186/s13059-014-0509-9'

  url "https://github.com/mourisl/Lighter/archive/v1.1.1.tar.gz"
  sha256 "9b29b87cd87f6d57ef8c39d22fb8679977128a1bdf557d8c161eae2816e374b7"
  head "https://github.com/mourisl/Lighter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a202957bd7ae808ada5b2a97dff037b2d1fa77d06b2e3f959500a82e6ba826e8" => :el_capitan
    sha256 "8307d8e6802c307b962f2236fc7ef9c9713be4ee178d6634fff3121bbcf96997" => :yosemite
    sha256 "29f093c9a6192a6d99637efe99fe7197e37eda3740ca86ab574f395be7723b3b" => :mavericks
    sha256 "e540b534e05c443bd4496325152245fb9efc23905d8e511ed31aca8fe77ab389" => :x86_64_linux
  end

  def install
    # do not use "CXXFLAGS=#{ENV.cxxflags}" as -Os compiles incorrectly
    system "make", "CXX=#{ENV.cxx}"
    bin.install "lighter"
    doc.install "README.md", "LICENSE"
  end

  test do
    system "#{bin}/lighter", "-h"
  end
end
