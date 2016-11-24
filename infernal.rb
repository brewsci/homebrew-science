class Infernal < Formula
  desc "Search DNA databases for RNA structure and sequence similarities"
  homepage "http://eddylab.org/infernal/"
  # doi "10.1093/bioinformatics/btp157"
  # tag "bioinformatics"

  url "http://eddylab.org/software/infernal/infernal-1.1.2.tar.gz"
  sha256 "ac8c24f484205cfb7124c38d6dc638a28f2b9035b9433efec5dc753c7e84226b"

  bottle do
    cellar :any_skip_relocation
    sha256 "230ae947e5fff0b1af7828ab3d26f06d8656ba3a4535710691b721dd6fac51b0" => :sierra
    sha256 "c19dd6cc6bdbb6e62b034c945464d374993981ae58aaa14077fccad935310569" => :el_capitan
    sha256 "4f472911166ddea3eefa6d4bb9c7ff70882673d8fe1063cb0b7e766fa5b92018" => :yosemite
    sha256 "7651ab8097ca8d88a64c3f85c83e3e6eedb7a99227bf04d6cef71058482d5b4d" => :x86_64_linux
  end

  deprecated_option "check" => "with-test"
  deprecated_option "with-check" => "with-test"

  option "with-test", "Run the test suite (`make check`). Takes a couple of minutes."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/cmsearch", "-h"
  end
end
