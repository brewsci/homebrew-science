require 'formula'

class CeleraAssembler < Formula
  homepage 'http://wgs-assembler.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/wgs-assembler/wgs-assembler/wgs-8.1/wgs-8.1.tar.bz2'
  sha1 '76f38c869b4876b414794b59e90d4f36c3e13488'

  # Doesn't build, because the 'kmer' directory is missing.
  #head 'https://svn.code.sf.net/p/wgs-assembler/svn/trunk'

  fails_with :clang do
    build 503
    cause "error: use of undeclared identifier 'use_safe_malloc_instead'"
  end

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
