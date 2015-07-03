class Wcslib < Formula
  homepage "http://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-5.7.tar.bz2"
  sha256 "a0822088ddd128618b5fbbbc1787f5a80568da4f4f53ce76545c9cf1f4140632"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "7300ee942f787b6a73ff680e25f9a70b605a0072" => :yosemite
    sha1 "17dc76d100bc1b3beefe0e26152d9edd8c277a8c" => :mavericks
    sha1 "d7e093d7f1cb1775dac992e75450830d840f39c2" => :mountain_lion
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
