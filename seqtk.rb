require 'formula'

class Seqtk < Formula
  homepage 'https://github.com/lh3/seqtk'
  url 'https://github.com/lh3/seqtk/archive/1.0.tar.gz'
  sha1 '926ec33df2c4dace334d2a01db072b3d5411bcc9'
  head 'https://github.com/lh3/seqtk.git'

  def install
    system 'make'
    bin.install (if build.head? then %w[seqtk tabtk] else 'seqtk' end)
    doc.install 'README.md'
  end

  test do
    system 'seqtk 2>&1 |grep -q seqtk'
  end
end
