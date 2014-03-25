require "formula"

class Wcslib < Formula
  homepage "http://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-4.21.tar.bz2"
  sha1 "35267fb33dd4f4e2463e259bcf4b3822218feb5d"

  option "with-pgsbox", "Build PGSBOX, a general curvilinear axis drawing routine for PGPLOT"
  option "with-fortran", "Build Fortran wrappers. Needed for --with-pgsbox."
  option "with-check", "Perform `make check`. Note, together --with-pgsbox it will display GUI"

  depends_on "cfitsio"
  depends_on "pgplot" if build.with? "pgsbox"
  depends_on :x11 if build.with? "pgsbox"
  depends_on :fortran if build.with? "fortran" or build.with? "pgsbox"

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-cfitsiolib=#{Formula["cfitsio"].opt_lib}",
            "--with-cfitsioinc=#{Formula["cfitsio"].opt_include}"]

    if build.with? "pgsbox"
      args << "--with-pgplotlib=#{Formula["pgplot"].opt_lib}"
      args << "--with-pgplotinc=#{Formula["pgplot"].opt_include}"
    else
      args << "--without-pgplot"
      args << "--disable-fortran" if build.without? "fortran"
    end

    system "./configure", *args

    ENV.deparallelize
    system "make"
    system "make check" if build.with? "check"
    system "make install"
  end
end
