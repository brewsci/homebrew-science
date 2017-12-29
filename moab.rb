class Moab < Formula
  desc "Mesh-Oriented datABase for evaluating mesh data"
  homepage "https://press3.mcs.anl.gov/sigma/moab-library/"
  url "http://ftp.mcs.anl.gov/pub/fathom/moab-5.0.0.tar.gz"
  sha256 "df5d5eb8c0d0dbb046de2e60aa611f276cbf007c9226c44a24ed19c570244e64"
  head "https://bitbucket.org/fathomteam/moab.git"

  bottle do
    cellar :any
    sha256 "072821d3130afad401b2180a6d6bfe76ceb716d0899c2f8f3cad6c37addf67e1" => :high_sierra
    sha256 "8b887f52a8acf00983caacbad8a6bab7fc93de480c78a0176695a1d6241fca6c" => :sierra
    sha256 "a6c240f0e59505610982d58f8087529809485d5629be5d371a3560beb5dbc7fe" => :el_capitan
    sha256 "d5ff1628e52d2b233cee714a5b0003e1016575a5656c29631c86ff0068805d70" => :x86_64_linux
  end

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
