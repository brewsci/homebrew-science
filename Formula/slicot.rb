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
    sha256 "8858d3476f8e51fc8725008fff3528216ac4510f712af26c158866da35194f53" => :sierra
    sha256 "0c3a86b77f39bd2302c67643c5adc4c117b2ced83179f5b431511d2f4f37adff" => :el_capitan
    sha256 "02e1f8d798ae9217639a2a2af6b561d4d32dbe2f90c2d75b47a3e577306ca7fc" => :yosemite
    sha256 "be0eb9dba27c75222eee021d8ca8ac1385fff0e3388587671efc7e169d98ff96" => :x86_64_linux
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
