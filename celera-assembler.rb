class CeleraAssembler < Formula
  homepage "http://wgs-assembler.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/wgs-assembler/wgs-assembler/wgs-8.2/wgs-8.2.tar.bz2"
  sha1 "a3c299e145bcdd1492bab4a677a445a308509e57"

  depends_on "samtools-0.1"

  # Fails with clang: https://sourceforge.net/p/wgs-assembler/bugs/262/
  needs :openmp

  def install
    ENV.j1
    system "make", "-C", "kmer", "install", "CC=#{ENV.cc}"
    system "make", "-C", "src", "CC=#{ENV.cc}", "LDLIBS=-rdynamic"
    arch = Pathname.new(Dir["*/bin"][0]).dirname
    libexec.install arch
    bin.install_symlink libexec/arch/"bin/runCA"
  end

  test do
    system "#{bin}/runCA"
  end
end
