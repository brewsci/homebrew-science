class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "ftp://ftp.rap.ucar.edu/pub/titan/radx/radx-20160128.src.tgz"
  mirror "ftp://ftp.rap.ucar.edu/pub/titan/radx/previous_releases/radx-20160128.src.tgz"
  version "20160128"
  sha256 "3fb2aeb1927fb95c1a1b74edc71d29f231d9c5301334a816e035d5aaaef25271"

  bottle do
    cellar :any
    sha256 "42dafadbe6296e1e2fa07cdd3c07bd4167db0262c3d674b85604ac9ea089fa9b" => :yosemite
    sha256 "da9f0d249a0cccee4925bd700a94dbc715fd4af92c0db62a1e64d60b996faec6" => :mavericks
    sha256 "0466e52d5f2b3deb7dce7d405842bcafc6eaa54c1cdf5621759c7843fe180db9" => :mountain_lion
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
