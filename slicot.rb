class Slicot < Formula
  homepage "http://www.slicot.org"
  url "http://ftp.de.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
  version "5.0+20101122"
  sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "f1f15e77810feb5452feb299e69e5c36c668c8a173fd345b06021c9028982e07" => :sierra
    sha256 "5a9e100e70b5e39998b1773bdbdf2f9afed90af4d3424b776a0016b726297e39" => :el_capitan
    sha256 "c9da0de7bd4de0c8e9cb030c64bf492de7b16365dbdeb11fdad3b2e900faeca3" => :yosemite
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
