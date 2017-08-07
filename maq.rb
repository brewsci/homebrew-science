class Maq < Formula
  desc "Builds assembly by mapping short reads to reference sequences"
  homepage "https://maq.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maq/maq/0.7.1/maq-0.7.1.tar.bz2"
  sha256 "e1671e0408b0895f5ab943839ee8f28747cf5f55dc64032c7469b133202b6de2"
  revision 1
  # tag "bioinformatics"
  # doi "10.1101/gr.078212.108"

  bottle do
    cellar :any_skip_relocation
    sha256 "83bda1812af30f94bb99097134977d38227dd8b99688ecca74c257fe07c52fee" => :sierra
    sha256 "fb4ab9e0b5169f4ceaa375ab79b0b0e829533ba51a1266a37faa840abc6cee81" => :el_capitan
    sha256 "87085cf34c60f1b9f528ffc66018c4bf6824f96f1a4e2247280830e1b7425433" => :yosemite
    sha256 "41de8572f1f96977532780f23ea7c62816a7a9d402f43fb831991d64b2c45808" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  patch do
    # Fixes compilation on mac and with newer gcc versions
    # See https://sourceforge.net/p/maq/bugs/33/
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2f18f5e22911865e2166d1f16d4758511ea8434c/maq/maq-0.7.1-compilation-fix.patch?full_index=1"
    sha256 "bb6b7eaa0bf4fb139cf9a3a0ec34fcc69670a214cf8f218987aacd3ad0b9b4d8"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    inreplace "Makefile", "CXXFLAGS =", "CXXFLAGS = -fpermissive -O2"
    Dir["scripts/*.pl"].each do |file|
      inreplace file, "/usr/bin/perl -w", "/usr/bin/env perl"
    end
    system "make", "install"
    doc.install %w[ChangeLog COPYING FUTURES INSTALL NEWS]
  end

  test do
    assert_match "Heng Li", shell_output("#{bin}/maq 2>&1", 1)
    assert_match "SNPfilter", shell_output("#{bin}/maq.pl 2>&1", 255)
  end
end
