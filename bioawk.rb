require 'formula'

class Bioawk < Formula
  homepage 'https://github.com/lh3/bioawk'
  head 'https://github.com/lh3/bioawk.git'

  def install
    ENV.j1
    system 'make'
    bin.install 'bioawk'
    doc.install 'README.md'
    man1.install({'awk.1' => 'bioawk.1'})
  end

  test do
    system 'bioawk --version'
  end
end
