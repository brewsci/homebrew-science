class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://www.eol.ucar.edu/system/files/software/radx/all-oss/radx-20160809.src_.tgz"
  version "20160809"
  sha256 "a071146df16b8abf926d35be4bc7d06b9204feeba8bbc8772858a7805bc5b92a"
  revision 5

  bottle do
    cellar :any
    sha256 "ce5104158b0bfd5feb81b6ff57ca9b45e43f6e70634837d821979cb74311df21" => :sierra
    sha256 "bbd4d6270ef58c00aa66ac4567a621419db98bc24345d8e34eba27edb5255837" => :el_capitan
    sha256 "2853715e744da2b615636fdb485fc6d2eacaaabd93cbb991e0f6b8ac700d03d6" => :yosemite
    sha256 "c3d6699f94686d562fb1cc01bfec85bcbc09b0e8c2f8e9910e91351c247d7eed" => :x86_64_linux
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
