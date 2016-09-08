class Tabtk < Formula
  desc "Toolkit for processing TAB-delimited format"
  homepage "https://github.com/lh3/tabtk"
  url "https://github.com/lh3/tabtk/archive/v0.1.tar.gz"
  sha256 "311df21ef04b4d396a7552ce1384bf056e1d6f87a5679d55e905ec6c8591b906"
  head "https://github.com/lh3/tabtk.git"
  # tab "bioinformatics"

  def install
    system "make"
    bin.install "tabtk"
    doc.install_metafiles
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tabtk 2>&1", 1)
  end
end
