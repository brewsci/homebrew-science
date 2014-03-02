require 'formula'

class Ray < Formula
  homepage 'http://denovoassembler.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/denovoassembler/Ray-2.3.1.tar.bz2'
  sha1 'cf7de83f671b38b51177de21604944c49e161f89'
  head 'https://github.com/sebhtml/ray.git'

  resource 'RayPlatform' do
    #homepage 'https://github.com/sebhtml/RayPlatform'
    url 'https://github.com/sebhtml/RayPlatform.git'
  end

  depends_on :mpi => :cxx

  fails_with :llvm do
    build 2336
    cause '"___gxx_personality_v0" ... ld: symbol(s) not found for architecture x86_64'
  end

  fails_with :gcc do
    build 5666
    cause "error: wrong number of arguments specified for '__deprecated__' attribute"
  end

  def install
    if build.head?
      rm 'RayPlatform' # Remove the broken symlink
      resource('RayPlatform').stage buildpath/'RayPlatform'
    end

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
