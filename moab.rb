class Moab < Formula
  desc "Mesh-Oriented datABase for evaluating mesh data"
  homepage "http://press3.mcs.anl.gov/sigma/moab-library/"
  url "http://ftp.mcs.anl.gov/pub/fathom/moab-4.9.2.tar.gz"
  sha256 "5d79e299dd9bf76d7cade434cde478bb6dc8290e5b574b25cc30ee96f35a203d"
  revision 1

  head "https://bitbucket.org/fathomteam/moab.git"

  bottle do
    cellar :any
    sha256 "f96e01a4fa09e29564628aaa1f46e87a547e6fd298d1834d454fc10b51e663b1" => :sierra
    sha256 "7ca1cccb8673a7ab276f0d106dafbdfd80172fa863c320727cf4d33c54aa4c4f" => :el_capitan
    sha256 "7dea4499ba1fde279ba4f09b899fb31302e08b6095cd27c5ae50feacbf30d401" => :yosemite
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
