require 'formula'

class CeleraAssembler < Formula
  homepage 'http://wgs-assembler.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/wgs-assembler/wgs-assembler/wgs-7.0/wgs-7.0.tar.bz2'
  sha1 'a5148b73040d94d80ed48df57b61f6d64504f1b4'

  def install
    ENV.j1
    system *%w[make -C kmer install]
    system *%w[make -C src]
    arch = Pathname.new(Dir['*/bin'][0]).dirname
    libexec.install arch
    bin.install_symlink libexec / arch / 'bin/runCA'
  end

  test do
    system "#{bin}/runCA"
  end
end
