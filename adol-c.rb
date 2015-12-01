class AdolC < Formula
  homepage "https://projects.coin-or.org/ADOL-C"
  url "http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.5.2.tgz"
  sha256 "2fa514d9799989d6379738c2bcf75070d9834e4d227eb32a5b278840893b2af9"

  bottle do
    revision 1
    sha256 "5905ef5d9019122e20139820eee3a9da55f5260300d7eb9a77863837c70cfd57" => :yosemite
    sha256 "d416356ba3c00b9dadd4ef547ffcbe011c24b0a97fc9fb8ee6b0dcb283a07998" => :mavericks
    sha256 "ddd86b44e40b432df17e909b02d429eac9b219311c96de6f851eac79c7dd0751" => :mountain_lion
  end

  head "https://projects.coin-or.org/svn/ADOL-C/trunk/", :using => :svn

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "colpack" => :recommended

  needs :cxx11

  def install
    ENV.cxx11

    # Configure may get automatically regenerated. So patch configure.ac.
    inreplace %w[configure configure.ac] do |s|
      s.gsub! "lib64", "lib"
    end

    args =  ["--prefix=#{prefix}", "--enable-sparse"]
    args << "--with-colpack=#{Formula["colpack"].opt_prefix}" if build.with? "colpack"
    args << "--with-openmp-flag=-fopenmp" if ENV.compiler != :clang
    args << "--enable-ulong" if MacOS.prefer_64_bit?

    ENV.append_to_cflags "-I#{buildpath}/ADOL-C/include/adolc"
    system "./configure", *args
    system "make", "install"
    system "make", "test"

    # move config.h to include as some packages require this info
    (include/"adolc").install "ADOL-C/src/config.h"
  end
end
