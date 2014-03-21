require 'formula'

class Sickle < Formula
  homepage 'https://github.com/najoshi/sickle'
  url 'https://github.com/najoshi/sickle/archive/v1.2.tar.gz'
  sha1 'ea69b11f45336a5232f940af94c7ad2d18e9aebc'
  head 'https://github.com/najoshi/sickle.git'

  # Fix a linker error
  unless build.head?
    patch do
      url "https://github.com/sjackman/sickle/commit/895207a.diff"
      sha1 "dba25e09e700770767629d659e4f12f743bb5ca1"
    end
  end

  def install
    system 'make'
    bin.install 'sickle'
  end

  def test
    system "#{bin}/sickle", '--version'
  end
end
