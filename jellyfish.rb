require 'formula'

class Jellyfish < Formula
  homepage 'http://www.cbcb.umd.edu/software/jellyfish/'
  url 'http://www.cbcb.umd.edu/software/jellyfish/jellyfish-1.1.10.tar.gz'
  sha1 '3e55b078623de02d88f1b3be825271215c243d52'

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      The cause of this is __int128 failing with clang; the author of
      Jellyfish is aware of this issue.
      EOS
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
