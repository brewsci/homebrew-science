class Maq < Formula
  homepage "http://maq.sourceforge.net/"
  # tag "bioinformatics"
  # doi "10.1101/gr.078212.108"

  url "https://downloads.sourceforge.net/project/maq/maq/0.7.1/maq-0.7.1.tar.bz2"
  sha256 "e1671e0408b0895f5ab943839ee8f28747cf5f55dc64032c7469b133202b6de2"

  depends_on "Getopt::Std" => :perl
  depends_on "File::Copy" => :perl

  fails_with :clang
  fails_with :llvm

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
    assert_match "Heng Li", shell_output("maq 2>&1", 1)
    assert_match "SNPfilter", shell_output("maq.pl 2>&1", 255)
  end
end
