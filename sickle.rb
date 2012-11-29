require 'formula'

class Sickle < Formula
  version '1.2'
  homepage 'https://github.com/najoshi/sickle'
  url 'https://github.com/najoshi/sickle.git',
      :revision => '032bf41f962ffeacca9a21ba222b6238760bc1cf'
  head 'https://github.com/najoshi/sickle.git'

  def install
    system 'make'
    bin.install 'sickle'
  end

  def test
    system "#{bin}/sickle", '--version'
  end
end
