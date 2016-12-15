class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://www.eol.ucar.edu/system/files/software/radx/all-oss/radx-20160809.src_.tgz"
  version "20160809"
  sha256 "a071146df16b8abf926d35be4bc7d06b9204feeba8bbc8772858a7805bc5b92a"
  revision 1

  bottle do
    cellar :any
    sha256 "a2a6404e674bd9418928f83dd7e8f59c9ae40a2fffec482bb1827ec148a6b8c1" => :sierra
    sha256 "5b86c9a1eac87b9510696258ba6f326227b0524b71abeb67b59474326bfeee41" => :el_capitan
    sha256 "975fe58f86427c5519a8eb1d9d7db2ee6c8d524917d39ab312b3f447382ed52a" => :yosemite
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
