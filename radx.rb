class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://www.eol.ucar.edu/system/files/software/radx/all-oss/radx-20160809.src_.tgz"
  version "20160809"
  sha256 "a071146df16b8abf926d35be4bc7d06b9204feeba8bbc8772858a7805bc5b92a"
  revision 4

  bottle do
    cellar :any
    sha256 "7665254a3449ab79f75d5cdc5b370f326c329fbaa47ccffdcab1d050d246f91b" => :sierra
    sha256 "72241b123f70428aeb81f76bad5652fb94888c6b3b346ae65cca6eadf5cb29ee" => :el_capitan
    sha256 "e1da0625a0f9175b05b6979f36d84df22e16aadf3f9489f755dc3373af694ac9" => :yosemite
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
