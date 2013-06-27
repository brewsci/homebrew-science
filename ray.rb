require 'formula'

class Ray < Formula
  homepage 'http://denovoassembler.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/denovoassembler/Ray-v2.2.0.tar.bz2'
  sha1 'c7e095bae64b0b14a35dbf05fe54e449a7117a3c'
  # The head does not build right now. Can you help us?
  # head 'https://github.com/sebhtml/ray.git'

  depends_on :mpi => :cxx

  fails_with :llvm do
    build 2336
    cause '"___gxx_personality_v0" ... ld: symbol(s) not found for architecture x86_64'
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make install"
    # The binary 'Ray' is installed in the prefix, but we want it in bin:
    bin.install 'Ray'
    rm prefix/'Ray'
  end

  test do
    system bin/'Ray', '--version'
  end
end
