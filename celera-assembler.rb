require 'formula'

class CeleraAssembler < Formula
  homepage 'http://wgs-assembler.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/wgs-assembler/wgs-assembler/wgs-8.1/wgs-8.1.tar.bz2'
  sha1 '76f38c869b4876b414794b59e90d4f36c3e13488'

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
