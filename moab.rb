class Moab < Formula
  desc "Mesh-Oriented datABase for evaluating mesh data"
  homepage "http://press3.mcs.anl.gov/sigma/moab-library/"
  url "http://ftp.mcs.anl.gov/pub/fathom/moab-4.9.2.tar.gz"
  sha256 "5d79e299dd9bf76d7cade434cde478bb6dc8290e5b574b25cc30ee96f35a203d"
  head "https://bitbucket.org/fathomteam/moab.git"

  bottle do
    sha256 "097016feed8abaee3de749c285bebe43e154939e0dd389d14bea50fc961c08fe" => :yosemite
    sha256 "1f0481c59eae7c0e97b2058eee421070e9b205c91c5ff7b977b73937d2d4b08c" => :mavericks
    sha256 "ae9c07a183340ac8d454c7e9a9b1b86a7e1f47c27bee5a557bfe416c6f63c434" => :mountain_lion
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
