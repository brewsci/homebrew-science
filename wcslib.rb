class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "http://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-5.16.tar.bz2"
  sha256 "ed031e0cf1cec0e9cabfc650423efa526fec341441865001c1e2c56bfffc99ef"
  revision 1

  bottle do
    cellar :any
    sha256 "81076955ebb0536666456bbb73bd22fde9a6a11f4016bd4ac35173fc6f8b924e" => :sierra
    sha256 "b1377f996a7f0c9c3e52d8eca95d44309dda75704297b4e3c3378be1e7d55653" => :el_capitan
    sha256 "c0ee66a5bf1d1411a5bbad81f3a4b7e3391b7bb339cf22a9cddfcd637fa17cb4" => :yosemite
    sha256 "47c69b7144501b5ac2005bcc2fc0957f8eafe744e9e5c4c608144f8504cfd838" => :x86_64_linux
  end

  option "with-pgplot", "Build PGSBOX, a general curvilinear axis drawing routine for PGPLOT"
  option "with-fortran", "Build Fortran wrappers. Needed for --with-pgsbox."
  option "with-test", "Perform `make check`. Note, together --with-pgsbox it will display GUI"

  deprecated_option "with-pgsbox" => "with-pgplot"
  deprecated_option "with-check" => "with-test"

  depends_on "cfitsio"
  depends_on "pgplot" => :optional
  depends_on :x11 if build.with? "pgplot"
  depends_on :fortran if build.with?("fortran") || build.with?("pgplot")

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-cfitsiolib=#{Formula["cfitsio"].opt_lib}",
            "--with-cfitsioinc=#{Formula["cfitsio"].opt_include}"]

    if build.with? "pgplot"
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
