require 'formula'

class Pear < Formula
  homepage 'http://sco.h-its.org/exelixis/web/software/pear/'
  url 'http://sco.h-its.org/exelixis/web/software/pear/files/pear-0.9.0-src.tar.gz'
  sha1 'a799aec02acc888a1107fe9171fd65b9be8a2712'

  def install
    system './configure',
      '--disable-debug',
      '--disable-dependency-tracking',
      '--disable-silent-rules',
      "--prefix=#{prefix}"
    system 'make', 'install'
  end

  test do
    system "#{bin}/pear --help 2>&1 |grep -q pear"
  end
end
