class Amos < Formula
  desc "Modular Open-Source Assembler"
  homepage "http://sourceforge.net/apps/mediawiki/amos/index.php?title=AMOS"
  # doi "10.1002/0471250953.bi1108s33"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/amos/amos/3.1.0/amos-3.1.0.tar.gz"
  sha256 "2d9f50e39186ad3dde3d3b28cc265e8d632430657f40fc3978ce34ab1b3db43b"
  revision 1

  bottle do
    sha256 "ccef615954fb792d254e88a47474c455a6be6e95e6d01286e81a870a5ce0b4d6" => :x86_64_linux
  end

  depends_on "expat" unless OS.mac?
  depends_on "blat" => :optional # for minimus2-blat
  depends_on "boost" => :recommended # for Bambus 2
  depends_on "mummer" => :recommended # for minimus2
  depends_on "Statistics::Descriptive" => :perl

  fails_with :clang do
    build 600
    cause "error: reference to 'hash' is ambiguous"
  end

  def install
    # http://seqanswers.com/forums/showthread.php?t=17802
    inreplace "src/Align/find-tandem.cc", "#include <sys/time.h>", "#include <sys/time.h>\n#include <getopt.h>"

    ENV.deparallelize
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--with-Boost-dir=#{Formula["boost"].opt_prefix}" if build.with? "boost"
    args << "BLAT=#{Formula["blat"].opt_bin}/blat" if build.with? "blat"

    args << "BUILD_QT4=no"

    if build.with? "mummer"
      args << "DELTAFILTER=#{Formula["mummer"].opt_libexec}/delta-filter"
      args << "SHOWCOORDS=#{Formula["mummer"].opt_libexec}/show-coords"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    The Perl modules have been installed in
      #{lib}/AMOS
      #{lib}/TIGR
    EOS
  end

  test do
    system "#{bin}/bank-transact", "-h"
  end
end
