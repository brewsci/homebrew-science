class Maq < Formula
  homepage "http://maq.sourceforge.net/"
  # tag "bioinformatics"
  # doi "10.1101/gr.078212.108"

  url "https://downloads.sourceforge.net/project/maq/maq/0.7.1/maq-0.7.1.tar.bz2"
  sha256 "e1671e0408b0895f5ab943839ee8f28747cf5f55dc64032c7469b133202b6de2"

  bottle do
    cellar :any
    sha256 "8ad73094199d8b664142722acc65ef2e1eb3c7e5ed636ed49ed0e71cc4061ebf" => :yosemite
    sha256 "a8d55037495dbd7c0329a3650cb37720e7dcef324d85fbba123cdb0440f9cbc9" => :mavericks
    sha256 "fc0b293027d0b9c0836fd2768362d3a8419f444a1154e65a393064d63f7e492b" => :mountain_lion
    sha256 "c10de77c9e5a9ee205eaacd1ccce8f86df2f14bfe0ad2b2f106bcff75d6d8bfe" => :x86_64_linux
  end

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
