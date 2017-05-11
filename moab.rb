class Moab < Formula
  desc "Mesh-Oriented datABase for evaluating mesh data"
  homepage "http://press3.mcs.anl.gov/sigma/moab-library/"
  url "http://ftp.mcs.anl.gov/pub/fathom/moab-4.9.2.tar.gz"
  sha256 "26611b8cc24f6b7df52eb4ecbd31523d61523da0524b5a2d066a7656e2e82ac5"
  revision 5

  head "https://bitbucket.org/fathomteam/moab.git"

  bottle do
    cellar :any
    sha256 "7c2e3687d5eae344e97807cbba5c5ce45e55671422586730f2fa79e2d5596c48" => :sierra
    sha256 "db8c6d0f08777fadff0881946331f25c307a49d4d4ed5fb068b8fb656f757677" => :el_capitan
    sha256 "1a76abbd366116a969f96ba212502ba32942b312ce7688adbfbd71670bf2cc37" => :yosemite
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
