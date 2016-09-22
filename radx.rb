class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "https://www.eol.ucar.edu/system/files/software/radx/all-oss/radx-20160809.src_.tgz"
  version "20160809"
  sha256 "a071146df16b8abf926d35be4bc7d06b9204feeba8bbc8772858a7805bc5b92a"

  bottle do
    cellar :any
    sha256 "8afbb1c3e0c04290a56e3ced7e313aaf1ace8e1a2f6a5a3a5b89cfd46f837d32" => :el_capitan
    sha256 "5edd71a1f53fd09ad34f8c8c9b6b3867ac77da52427166b1ea2514a3bd8b93ca" => :yosemite
    sha256 "575425f11e273256da4e1179e2d05466f0f4ecfe6051a7b02d1d9377cf8a082b" => :mavericks
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
