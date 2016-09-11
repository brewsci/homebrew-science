class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://www.eol.ucar.edu/system/files/software/radx/all-oss/radx-20160327.src_.tgz"
  mirror "ftp://ftp.rap.ucar.edu/pub/titan/radx/previous_releases/radx-20160327.src.tgz"
  version "20160327"
  sha256 "3535a724170b06360c8b187ae330c064898bc72e98b839e215c6cffa8b6f2294"
  revision 1

  bottle do
    cellar :any
    sha256 "fde2404302b494fc9de30dca3871bbd05836c4de71c5b968ebfaa29a138bb15b" => :el_capitan
    sha256 "bc7d02e0853b0341c7a32730b35e2796af8e4827e421718e72f2172bb1025c90" => :yosemite
    sha256 "68807cb547a3019542884b39e5b848ada5e6180ab46e17fad6b1ce6eb8296ead" => :mavericks
  end

  depends_on "hdf5"
  depends_on "udunits"
  depends_on "netcdf" => "with-cxx-compat"
  depends_on "fftw"

  # Prevents build failure on Mac OS X 10.8 and below
  # FIXME: Remove when it gets fixed upstream (reported)
  patch do
    url "https://gist.githubusercontent.com/tomyun/ee3a910e07c9ccc4610e/raw/3b151798488c5dc7091506a25ac704dad6687e97/radx-fix-sockutil-mac.diff"
    sha256 "19d55b7beb985a6facc75a02a92739c3a4208797eea2cbd0f2353a86c7aa90db"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/RadxPrint", "-h"
  end
end
