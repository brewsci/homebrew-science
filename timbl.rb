class Timbl < Formula
  desc "Memory-based learning algorithms"
  homepage "https://ilk.uvt.nl/timbl/"
  url "https://github.com/LanguageMachines/timbl/releases/download/v6.4.9/timbl-6.4.9.tar.gz"
  sha256 "02d58dc4a1b97cdd799541a597b6db5b4b8922614a02160a8c2d27c221db2f78"

  bottle do
    cellar :any
    sha256 "b296c9318d54e436d1901e148389508fd1bd64ebf9bdab6551cbbebf87cbc776" => :sierra
    sha256 "5061707d7b9e661af260d8f4522527be37f028f9d15839a7085e6f6d47baeece" => :el_capitan
    sha256 "ff0964f561ac630f3c298d0b2a8cdded34ba21a556cbaba5ca2d72c4bcb0cfd6" => :yosemite
    sha256 "2de1a1d0ed396541cdbf2bc092621e948be908e5ab17b32677cfcfe627f6b17b" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "ticcutils"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
