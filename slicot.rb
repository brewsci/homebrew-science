require 'formula'

class Slicot < Formula
  homepage 'http://www.slicot.org'
  url 'http://ftp.de.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz'
  version '5.0+20101122'
  sha1 'ec240abbf6d3d60da3a7dc21d22104abdfd86bd8'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "e0e4a0778475c65552e3da2891df7b11b198e5e0" => :yosemite
    sha1 "c92aff9daacbedaa31a71abbb0d38911e7fc2f2d" => :mavericks
    sha1 "c5ff979aad3b5f0164789bf5cba02787ca8acdd5" => :mountain_lion
  end

  option 'with-default-integer-8', 'Build with 8-byte-wide integer type'

  depends_on :fortran

  def install
    args = [
      "FORTRAN=#{ENV.fc}",
      "LOADER=#{ENV.fc}",
    ]

    slicotlibname = "libslicot_pic.a"
    system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../#{slicotlibname}", *args
    lib.install "#{slicotlibname}"

    if build.with? "default-integer-8"
      system "make", "clean"
      slicotlibname = "libslicot64_pic.a"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8", "SLICOTLIB=../#{slicotlibname}", *args
      lib.install "#{slicotlibname}"
    end
  end
end
