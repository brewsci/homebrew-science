class Moab < Formula
  desc "Mesh-Oriented datABase for evaluating mesh data"
  homepage "http://press3.mcs.anl.gov/sigma/moab-library/"
  url "http://ftp.mcs.anl.gov/pub/fathom/moab-4.9.2.tar.gz"
  sha256 "26611b8cc24f6b7df52eb4ecbd31523d61523da0524b5a2d066a7656e2e82ac5"
  revision 5

  head "https://bitbucket.org/fathomteam/moab.git"

  bottle do
    cellar :any
    sha256 "157b0599a9f0bc0122888d889a5d74fe23956b06a39931f60a8b56ea53953057" => :sierra
    sha256 "152853885760446f16699d590c1d6dca70ff1f604241fbcc226c8b58ba47faad" => :el_capitan
    sha256 "fc037f88f1c7bc2d0a9737e720abb5b452121214c5c27d38a5bbea240dc7dd8c" => :yosemite
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
