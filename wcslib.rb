class Wcslib < Formula
  homepage "http://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-5.12.tar.bz2"
  sha256 "50ff182920541bea156e7f53588cdfba1754b1bdcd0bc64a136a5d124af98de4"

  bottle do
    cellar :any
    sha256 "7dc901639118d93a9fe6d33f0c132375d3d0d7fb9e5776c87c2b8d0c189d63a1" => :el_capitan
    sha256 "b9b4f97cbd008cbfdadf1b31206db564c491812589d865e1da8d4784e85638f4" => :yosemite
    sha256 "d2a5758f92c0fc1e703fd97b4394e3381e8514204a31c989d902a3e02fce8d8f" => :mavericks
  end

  option "with-pgsbox", "Build PGSBOX, a general curvilinear axis drawing routine for PGPLOT"
  option "with-fortran", "Build Fortran wrappers. Needed for --with-pgsbox."
  option "with-check", "Perform `make check`. Note, together --with-pgsbox it will display GUI"

  depends_on "cfitsio"
  depends_on "homebrew/x11/pgplot" if build.with? "pgsbox"
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
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
