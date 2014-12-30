class Amos < Formula
  homepage "http://sourceforge.net/apps/mediawiki/amos/index.php?title=AMOS"
  #doi "10.1002/0471250953.bi1108s33"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/amos/amos/3.1.0/amos-3.1.0.tar.gz"
  sha1 "28e799e37713594ba7147d300ecae6574beb14a4"

  depends_on "blat" => :optional # for minimus2-blat
  depends_on "boost" => :recommended # for Bambus 2
  depends_on "mummer" => :recommended # for minimus2
  depends_on "qt" => [:optional, "with-qt3support"] # for AMOS GUIs
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

    if build.with? "qt"
      args << "--with-qmake-qt4=#{Formula["qt"].opt_bin}/qmake"
    else
      args << "BUILD_QT4=no"
    end

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
