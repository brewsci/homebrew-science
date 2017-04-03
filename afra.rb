class Afra < Formula
  desc "Alignmen-free support values"
  homepage "https://github.com/EvolBioInf/afra"
  # tag "bioinformatics"

  url "https://github.com/EvolBioInf/afra/releases/download/v2.1/afra-v2.1.tar.gz"
  sha256 "e4042de524bc6a979a56fb6f7dba4e163e97ba1047854a385ddebc3ea090d2d3"
  head "https://github.com/EvolBioInf/afra.git"

  bottle do
    cellar :any
    sha256 "ef98735d2aa088b912caee2d31d9096af11eaed2dc1e539f33ba85d13320a65d" => :sierra
    sha256 "a9ba59a547b32352bc65c26276b49d5cdcd2b9ff41a7ea169365d46f992ea0f2" => :el_capitan
    sha256 "4e49727c5c250b6befd15f253829c75e597584121402b6d85e0b1b11fe8d392e" => :yosemite
    sha256 "1f0d6421878a65f07582dd81642f351f4386022bf33ea79a8087178a048fe975" => :mavericks
    sha256 "f7fb0b66080a819db4d9c2ca7f31bff05fb37caa67e07bbeb38b88f3599cc869" => :x86_64_linux
  end

  needs :openmp

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "quartet", shell_output("#{bin}/afra --help 2>&1", 0)
  end
end
