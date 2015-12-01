class Slicot < Formula
  homepage "http://www.slicot.org"
  url "http://ftp.de.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
  version "5.0+20101122"
  sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  revision 1

  bottle do
    cellar :any
    sha256 "96e0edf82f910089e19ecedd8b4c68c233cfb505e14f1f93d63d3474ccee7f81" => :yosemite
    sha256 "850b2352c760558f54833101524127ab14ee928a3e844224e888d9893f991b68" => :mavericks
    sha256 "af13b9a9543b1a2f6d74aa1776dd1d3b72a2a28e7112098300c93c176a92dc10" => :mountain_lion
  end

  option "with-default-integer-8", "Build with 8-byte-wide integer type"

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
