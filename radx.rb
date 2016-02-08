class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "ftp://ftp.rap.ucar.edu/pub/titan/radx/radx-20160128.src.tgz"
  mirror "ftp://ftp.rap.ucar.edu/pub/titan/radx/previous_releases/radx-20160128.src.tgz"
  version "20160128"
  sha256 "3fb2aeb1927fb95c1a1b74edc71d29f231d9c5301334a816e035d5aaaef25271"

  bottle do
    cellar :any
    sha256 "04eefefde0db927cd0de942e5bbc058c6940c8ce0c7d4e4bf5f85461bf61b1dc" => :el_capitan
    sha256 "3de141c69237dc808e93d5477dfed34adf3b54a4a85d3edf92209590905a9d66" => :yosemite
    sha256 "8f609b2c3014095582254d9711e6f12f9bf96e2c8504c0b8f1cd35b577703755" => :mavericks
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
