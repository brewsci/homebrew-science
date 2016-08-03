class Wcslib < Formula
  homepage "http://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-5.12.tar.bz2"
  sha256 "50ff182920541bea156e7f53588cdfba1754b1bdcd0bc64a136a5d124af98de4"
  revision 1

  bottle do
    cellar :any
    sha256 "10e40cde3232d818fa1b34428f51237f95ecb2010bbd68e8fb7d83bfe3f836f3" => :el_capitan
    sha256 "afcd4afed0d1e3bdd2f0e3472a35031d016358ee4727c25fb2917471bf877746" => :yosemite
    sha256 "993bb97dc1d80d63d89fdde3d944c88d251e2fc557d7001adfe853181ed96749" => :mavericks
  end

  option "with-pgsbox", "Build PGSBOX, a general curvilinear axis drawing routine for PGPLOT"
  option "with-fortran", "Build Fortran wrappers. Needed for --with-pgsbox."
  option "with-check", "Perform `make check`. Note, together --with-pgsbox it will display GUI"

  depends_on "cfitsio"
  depends_on "homebrew/x11/pgplot" if build.with? "pgsbox"
  depends_on :x11 if build.with? "pgsbox"
  depends_on :fortran if build.with?("fortran") || build.with?("pgsbox")

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
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
