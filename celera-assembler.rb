require 'formula'

class CeleraAssembler < Formula
  homepage 'http://wgs-assembler.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/wgs-assembler/wgs-assembler/wgs-8.0/wgs-8.0.tar.bz2'
  sha1 'b05b2bc275998ba65646ce849adfd0bac806655c'

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
