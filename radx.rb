class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://www.eol.ucar.edu/system/files/software/radx/all-oss/radx-20160809.src_.tgz"
  version "20160809"
  sha256 "a071146df16b8abf926d35be4bc7d06b9204feeba8bbc8772858a7805bc5b92a"
  revision 4

  bottle do
    cellar :any
    sha256 "87897b7163a8631fac0b7835b4c5037f07020e973ee3f926d818ac878920d486" => :sierra
    sha256 "b4088ca2baf6dfc0f9393773a985e132ff0baf213a31a26fadc06848f3a7c163" => :el_capitan
    sha256 "59714fab0a332d7f5963a8f1a3a7ad6a1af01e83af3010e50b10d8d78e653ee5" => :yosemite
  end

  depends_on "hdf5"
  depends_on "udunits"
  depends_on "netcdf"
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
