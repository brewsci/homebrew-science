class Tabtk < Formula
  desc "Toolkit for processing TAB-delimited format"
  homepage "https://github.com/lh3/tabtk"
  url "https://github.com/lh3/tabtk/archive/v0.1.tar.gz"
  sha256 "311df21ef04b4d396a7552ce1384bf056e1d6f87a5679d55e905ec6c8591b906"
  head "https://github.com/lh3/tabtk.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "bf8c44ad2b333a40490e785a0fa9b71fec66c47f104c92791bab96ed4a07b41b" => :el_capitan
    sha256 "7e78e89f6582dc4ee90d35eacde0ed1e722dba7c01c3f4bca25eb9f4db59d37a" => :yosemite
    sha256 "fda99507d62f92c5a5e10d1af97850631fc8ebb97ab53d265d7c81fbc535c78e" => :mavericks
    sha256 "edfe0eb28b8641910e8ad91854521a197c0b41d4d2a14febb10f9fdf200c02ac" => :x86_64_linux
  end

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
