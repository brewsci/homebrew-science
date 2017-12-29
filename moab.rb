class Moab < Formula
  desc "Mesh-Oriented datABase for evaluating mesh data"
  homepage "https://press3.mcs.anl.gov/sigma/moab-library/"
  url "http://ftp.mcs.anl.gov/pub/fathom/moab-5.0.0.tar.gz"
  sha256 "df5d5eb8c0d0dbb046de2e60aa611f276cbf007c9226c44a24ed19c570244e64"
  head "https://bitbucket.org/fathomteam/moab.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "netcdf"
  depends_on "hdf5"
  depends_on :fortran
  depends_on "openblas" unless OS.mac?

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-shared",
      "--enable-static",
      "--prefix=#{prefix}",
      "--with-netcdf=#{Formula["netcdf"].opt_prefix}",
      "--with-hdf5=#{Formula["hdf5"].opt_prefix}",
      "--without-cgns",
    ]

    system "autoreconf", "-fi"
    system "./configure", *args
    system "make", "install"
    system "make", "check"
  end

  test do
    system bin/"mbconvert", "-h"
  end
end
