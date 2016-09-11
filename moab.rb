class Moab < Formula
  desc "Mesh-Oriented datABase for evaluating mesh data"
  homepage "http://press3.mcs.anl.gov/sigma/moab-library/"
  url "http://ftp.mcs.anl.gov/pub/fathom/moab-4.9.2.tar.gz"
  sha256 "5d79e299dd9bf76d7cade434cde478bb6dc8290e5b574b25cc30ee96f35a203d"
  head "https://bitbucket.org/fathomteam/moab.git"

  bottle do
    cellar :any
    sha256 "fa7cad15c7f86546a90e6c308a758025ddfea152340a74d46ff4b5ca52551eee" => :el_capitan
    sha256 "e863c8326fd5d0408322cf4b191b447da12127b849fd9906f1b44463ae612c0e" => :yosemite
    sha256 "d21fd72720b56e8344bac3bc163dfe89795e48b8f2cafdc4c54c5234e9bcd10d" => :mavericks
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
