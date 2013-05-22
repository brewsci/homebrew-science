require 'formula'

class Wcslib < Formula
  homepage 'http://www.atnf.csiro.au/people/mcalabre/WCS/'
  url 'ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-4.17.tar.bz2'
  sha1 '74ec5fd6ec93e9a09798598c3738b3d4bc99b3e7'

  option 'with-pgsbox', 'Build PGSBOX, a general curvilinear axis drawing routine for PGPLOT'
  option 'with-fortran', "Build Fortran wrappers. Needed for --with-pgsbox."
  option 'check', "Perform `make check`. Note, together --with-pgsbox it will display GUI"

  depends_on 'cfitsio'
  depends_on 'pgplot' if build.include? 'with-pgsbox'
  depends_on :x11 if build.include? 'with-pgsbox'

  def install
    ENV.fortran if build.include? 'with-fortran' or build.include? 'with-pgsbox'

    args = [ "--disable-debug",
             "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--with-cfitsiolib=#{Formula.factory('cfitsio').opt_prefix}/lib",
             "--with-cfitsioinc=#{Formula.factory('cfitsio').opt_prefix}/include" ]

    if build.include? 'with-pgsbox'
      args << "--with-pgplotlib=#{Formula.factory('pgplot').opt_prefix}/lib"
      args << "--with-pgplotinc=#{Formula.factory('pgplot').opt_prefix}/include"
    else
      args << "--without-pgplot"
      args << "--disable-fortran" unless build.include? 'with-fortran'
    end

    system "./configure", *args

    ENV.deparallelize
    system "make"
    system "make check" if build.include? 'check'
    system "make install"
  end
end
