require 'formula'

class AdolC < Formula
  homepage "https://projects.coin-or.org/ADOL-C"
  url "http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.5.0.tgz"
  sha1 "3d3307037bb622499141a0e1eecfee195f3dcfcb"

  head 'https://projects.coin-or.org/svn/ADOL-C/trunk/', :using => :svn

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on :libtool  => :build
  depends_on "colpack" => [:recommended, 'with-libc++']

  # The 2.5.0 release won't build cleanly and play well with colpack.
  # Apply a mighty patch that essentially builds head.
  # This *should* disappear!
  def patches
    {:p0 => "https://gist.githubusercontent.com/dpo/ae679225d8850cfa4608/raw/1ea3838c29279f207c0d8827fdc8a0a2c9fca5b5/adol-c.patch"}
  end unless build.head?

  fails_with :llvm

  fails_with :gcc do
    build 5666
    cause "C++ compilation error."
  end

  def install
    ENV.cxx11 if ENV.compiler == :clang

    # Configure may get automatically regenerated. So patch configure.ac.
    inreplace %w(configure configure.ac) do |s|
      s.gsub! "lib64", "lib"
    end

    args =  ["--prefix=#{prefix}", "--enable-sparse"]
    args << "--with-colpack=#{Formula['colpack'].prefix}" if build.with? "colpack"
    args << "--with-openmp-flag=-fopenmp" if ENV.compiler != :clang
    args << "--enable-ulong" if MacOS.prefer_64_bit?

    ENV.append_to_cflags   "-I#{buildpath}/ADOL-C/include/adolc"
    system "./configure", *args
    system "make install"
    system "make test"
  end
end
