require 'formula'

class Sickle < Formula
  homepage 'https://github.com/najoshi/sickle'
  url 'https://github.com/najoshi/sickle/archive/v1.2.tar.gz'
  sha1 'ea69b11f45336a5232f940af94c7ad2d18e9aebc'
  head 'https://github.com/najoshi/sickle.git'

  # Fix a linker error
  def patches
    'https://github.com/sjackman/sickle/commit/895207a.diff' unless build.head?
  end

  def install
    system 'make'
    bin.install 'sickle'
  end

  def test
    system "#{bin}/sickle", '--version'
  end
end
