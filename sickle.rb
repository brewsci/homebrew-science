require 'formula'

class Sickle < Formula
  homepage 'https://github.com/najoshi/sickle'
  url 'https://github.com/najoshi/sickle/archive/v1.33.tar.gz'
  sha1 '593274fb7e12a52c9086dff69623aedca1799a5c'
  head 'https://github.com/najoshi/sickle.git'

  def install
    system 'make'
    bin.install 'sickle'
  end

  test do
    system "#{bin}/sickle", '--version'
  end
end
