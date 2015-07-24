class Wcslib < Formula
  homepage "http://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-5.7.tar.bz2"
  sha256 "a0822088ddd128618b5fbbbc1787f5a80568da4f4f53ce76545c9cf1f4140632"

  bottle do
    cellar :any
    sha256 "b041274c39a79f7043f883ccc5e914e8bb66c35084a4cd17fa8b528faa205880" => :yosemite
    sha256 "c8595299a62857f9ef20221d664e71093bc88ab8334c331075e67226f8717933" => :mavericks
    sha256 "7d2ed55eef5dbc5504b5eba8a2a986ae3b32182ba9c4baff8d75ee797ec5f51f" => :mountain_lion
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
