class Miniasm < Formula
  desc "Ultrafast de novo assembly for long noisy reads"
  homepage "https://github.com/lh3/miniasm"
  # tag "bioinformatics"

  url "https://github.com/lh3/miniasm/archive/v0.2.tar.gz"
  sha256 "177cbb93dbdd3da73e3137296f7822ede830af10339aa7f84fc76afab95a1be6"

  head "https://github.com/lh3/miniasm.git"

  depends_on "minimap"

  def install
    system "make"
    bin.install "miniasm", "minidot"
    pkgshare.install "misc"
  end

  test do
    assert_match "in.paf", shell_output("#{bin}/miniasm 2>&1", 1)
  end
end
