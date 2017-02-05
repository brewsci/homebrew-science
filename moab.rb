class Moab < Formula
  desc "Mesh-Oriented datABase for evaluating mesh data"
  homepage "http://press3.mcs.anl.gov/sigma/moab-library/"
  url "http://ftp.mcs.anl.gov/pub/fathom/moab-4.9.2.tar.gz"
  sha256 "26611b8cc24f6b7df52eb4ecbd31523d61523da0524b5a2d066a7656e2e82ac5"
  revision 3

  head "https://bitbucket.org/fathomteam/moab.git"

  bottle do
    cellar :any
    sha256 "63cc1233614adf78249afe332243cc9e6ee7ee191fcd5e1f01e0b1f5f2a374b4" => :sierra
    sha256 "f4b3b5933858bc18da4551abb6e71795c1bb59c6a9dfa5f33c891401d6bd973d" => :el_capitan
    sha256 "98495b01d1a0abd376f0adec665bc09bf8b883842faa478abda9155acf4fce83" => :yosemite
    sha256 "04ac86fb24f36f10e3cbab9f4d1000f1021ee22640fbde3f1213c389d0916684" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "netcdf"
  depends_on "hdf5"
  depends_on :fortran

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

    cd lib do
      # Move non-libraries out of lib
      prefix.install %w[iMesh-Defs.inc moab.config moab.make MOABConfig.cmake]
    end
  end

  test do
    system bin/"mbconvert", "-h"
  end
end
