require "formula"

class Blast < Formula
  homepage "http://blast.ncbi.nlm.nih.gov/"
  #doi "10.1016/S0022-2836(05)80360-2"
  url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.29/ncbi-blast-2.2.29+-src.tar.gz"
  version "2.2.29"
  sha1 "6b1e8a4b172ae01dbf2ee1ec3b4c4fce392f3eca"

  option "with-dll", "Create dynamic binaries instead of static"
  option "without-check", "Skip the self tests (Boost not needed)"

  depends_on "boost" if build.with? "check"
  depends_on "freetype" => :optional
  depends_on "gnutls"   => :optional
  depends_on "hdf5"     => :optional
  depends_on "jpeg"     => :recommended
  depends_on "libpng"   => :recommended
  depends_on "pcre"     => :recommended
  depends_on :mysql     => :optional
  depends_on :python

  fails_with :clang do
    build 503
    cause "error: 'bits/c++config.h' file not found"
  end

  fails_with :gcc => "4.9" do
    cause "error: must #include <typeinfo> before using typeid"
  end

  def install
    args = %W[--prefix=#{prefix} --without-debug --with-mt]

    args << (build.with?("freetype") ? "--with-freetype=#{Formula["freetype"].opt_prefix}" : "--without-freetype")
    args << (build.with?("gnutls") ? "--with-gnutls=#{Formula["gnutls"].opt_prefix}" : "--without-gnutls")
    args << (build.with?("jpeg")   ? "--with-jpeg=#{Formula["jpeg"].opt_prefix}" : "--without-jpeg")
    args << (build.with?("libpng") ? "--with-png=#{Formula["libpng"].opt_prefix}" : "--without-png")
    args << (build.with?("pcre")   ? "--with-pcre=#{Formula["pcre"].opt_prefix}" : "--without-pcre")

    args << "--with-dll" if build.with? "dll"
    # Boost is used only for unit tests.
    args << (build.with?("check") ? "--with-check" : "--without-boost")

    cd "c++" do
      system "./configure", *args
      system "make"
      system "make install"

      # libproj.a conflicts with the formula proj
      # mv gives the error message:
      # fileutils.rb:1552:in `stat'
      # Errno::ENOENT: No such file or directory -
      # $HOMEBREW_PREFIX/Cellar/blast/2.2.28/lib/libaccess-static.a
      libexec.mkdir
      system "mv #{lib}/lib*.a #{libexec}/." if build.without? "dll"
    end
  end

  def caveats; <<-EOS.undent
    Using the option '--with-dll' will create dynamic binaries instead of
    static. The NCBI Blast static installation is approximately 7 times larger
    than the dynamic.

    Static binaries should be used for speed if the executable requires
    fast startup time, such as if another program is frequently restarting
    the blast executables.

    Static libraries are installed in #{libexec}
    EOS
  end

  test do
    system 'blastn -version'
  end
end
