class Slicot < Formula
  desc "Fortran 77 algorithms for computations in systems and control theory"
  homepage "http://www.slicot.org"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
  version "5.0+20101122"
  sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "f1f15e77810feb5452feb299e69e5c36c668c8a173fd345b06021c9028982e07" => :sierra
    sha256 "5a9e100e70b5e39998b1773bdbdf2f9afed90af4d3424b776a0016b726297e39" => :el_capitan
    sha256 "c9da0de7bd4de0c8e9cb030c64bf492de7b16365dbdeb11fdad3b2e900faeca3" => :yosemite
  end

  depends_on :fortran

  def install
    args = [
      "FORTRAN=#{ENV.fc}",
      "LOADER=#{ENV.fc}",
    ]
    system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a", *args
    system "make", "clean"
    system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
           "SLICOTLIB=../libslicot64_pic.a", *args
    lib.install "libslicot_pic.a", "libslicot64_pic.a"
  end
end
