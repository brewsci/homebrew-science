require 'formula'

class Ray < Formula
  homepage 'http://denovoassembler.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/denovoassembler/Ray-2.3.0.tar.bz2'
  sha1 '1b1c085d2d53431bcf671799f0ce351d835ba072'
  # The head does not build right now. Can you help us?
  # head 'https://github.com/sebhtml/ray.git'

  depends_on :mpi => :cxx

  fails_with :clang do
    build 500
    cause "error: use of overloaded operator '>>' is ambiguous"
  end

  fails_with :llvm do
    build 2336
    cause '"___gxx_personality_v0" ... ld: symbol(s) not found for architecture x86_64'
  end

  fails_with :gcc do
    build 5666
    cause "error: wrong number of arguments specified for '__deprecated__' attribute"
  end

  def patches
    'https://github.com/sebhtml/ray/commit/e1ad06d8cb55427ff4bcca647b7bd4e4416619e3.patch'
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
