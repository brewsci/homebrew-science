class Bwtdisk < Formula
  desc "Compute large BWTs in external memory"
  homepage "https://people.unipmn.it/manzini/bwtdisk/"
  url "https://people.unipmn.it/manzini/bwtdisk/bwtdisk.0.9.0.tgz"
  sha256 "ef053144d1756d6c8b4c01fc822897fd2d99ff652a9745e418c813d7ab5f33fa"

  def install
    system "make"
    bin.install %w[bwte text_conv text_count text_rev unbwti]
    doc.install %w[CHANGES COPYING README doc/bwtdisk.pdf]
    include.install "bwtext_defs.h"
    lib.install "bwtext.a" => "libbwtext.a"
  end

  test do
    system "#{bin}/bwte 2>&1 |grep -q bwte"
  end
end
