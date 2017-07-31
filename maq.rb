class Maq < Formula
  desc "Builds assembly by mapping short reads to reference sequences"
  homepage "https://maq.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maq/maq/0.7.1/maq-0.7.1.tar.bz2"
  sha256 "e1671e0408b0895f5ab943839ee8f28747cf5f55dc64032c7469b133202b6de2"
  revision 1
  # tag "bioinformatics"
  # doi "10.1101/gr.078212.108"

  bottle do
    cellar :any
    sha256 "8ad73094199d8b664142722acc65ef2e1eb3c7e5ed636ed49ed0e71cc4061ebf" => :yosemite
    sha256 "a8d55037495dbd7c0329a3650cb37720e7dcef324d85fbba123cdb0440f9cbc9" => :mavericks
    sha256 "fc0b293027d0b9c0836fd2768362d3a8419f444a1154e65a393064d63f7e492b" => :mountain_lion
    sha256 "c10de77c9e5a9ee205eaacd1ccce8f86df2f14bfe0ad2b2f106bcff75d6d8bfe" => :x86_64_linux
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
