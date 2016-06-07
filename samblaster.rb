class Samblaster < Formula
  desc "Tool to mark duplicates in SAM files"
  homepage "https://github.com/GregoryFaust/samblaster"
  # doi "10.1093/bioinformatics/btu314"
  # tag "bioinformatics"

  url "https://github.com/GregoryFaust/samblaster/archive/v.0.1.22.tar.gz"
  sha256 "829f6036cf081a2a64716bbb1940d4b5fef96979adfee8650c1ffe4ce6f46c8b"
  head "https://github.com/GregoryFaust/samblaster"

  bottle do
    cellar :any
    sha256 "52e903cdfb8d83b45ed5196cf0677691ce2e82a1de3ae55fe0d0f6aeff7188f7" => :yosemite
    sha256 "8fa4a1f0d5e951e52a3549ba510e4d2c1d259c74af398315a72f93eb927f1c09" => :mavericks
    sha256 "ad7a536d87ec4f4d36307590037ff597898cef59d1ab81b4ef1aeac5e2c38a71" => :mountain_lion
    sha256 "7194f37e01f0ac74b738cb36c30c29e0fb8822068b13ba20d3db84cea3bb7cbb" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "samblaster"
  end

  test do
    system "#{bin}/samblaster", "--version"
  end
end
