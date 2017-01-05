class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://www.eol.ucar.edu/system/files/software/radx/all-oss/radx-20160809.src_.tgz"
  version "20160809"
  sha256 "a071146df16b8abf926d35be4bc7d06b9204feeba8bbc8772858a7805bc5b92a"
  revision 2

  bottle do
    cellar :any
    sha256 "4b46d8576a9f3dffd1cfb25ad236db996290a62ec19ad41b06562638031c58b1" => :sierra
    sha256 "2818bc7758febf6ae381077ff21c3ea7cbafaa4a835aca6440dbad3a7476d686" => :el_capitan
    sha256 "321a724468daf88007486b781445771d0e413f617ff40ef6eb6b85d849baf63c" => :yosemite
    sha256 "9aa201c5d1d02874841a78662c0f02bc674420b1e326535750a2902ff5ccd41a" => :x86_64_linux
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
