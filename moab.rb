class Moab < Formula
  desc "Mesh-Oriented datABase for evaluating mesh data"
  homepage "http://press3.mcs.anl.gov/sigma/moab-library/"
  url "http://ftp.mcs.anl.gov/pub/fathom/moab-4.9.2.tar.gz"
  sha256 "26611b8cc24f6b7df52eb4ecbd31523d61523da0524b5a2d066a7656e2e82ac5"
  revision 3

  head "https://bitbucket.org/fathomteam/moab.git"

  bottle do
    cellar :any
    sha256 "073c5e204eaf423f55e440b43e988962d6de6d4cd442aa29b56c6e7752854821" => :sierra
    sha256 "9250a6150814e0d8b33daed06c701ad02dbab9be88e2f7ea278142eee06537c6" => :el_capitan
    sha256 "22d7412380f93f2062e2941205c0d4851e84dd891d8da7d42fa407ef712caadd" => :yosemite
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
