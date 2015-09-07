class Radx < Formula
  desc "Software package for radial radar data"
  homepage "https://www.ral.ucar.edu/projects/titan/docs/radial_formats/radx.html"
  url "ftp://ftp.rap.ucar.edu/pub/titan/radx/radx-20150826.src.tgz"
  mirror "ftp://ftp.rap.ucar.edu/pub/titan/radx/previous_releases/radx-20150826.src.tgz"
  version "20150826"
  sha256 "d379b956bf19ff903dcfa6a5ca134d5241be3085e6d97acca70dd7ec42da8ce3"

  bottle do
    cellar :any
    sha256 "a3d0093a6a20030cf9a844365f3c7269c6c3bf7e7a6e5d9dfe216b48c5fce8ae" => :yosemite
    sha256 "e255889b4e6e80c15b32df90343dce5803a3705762f4965f54d60217cebcc1f0" => :mavericks
    sha256 "33bb93526f66f0023cd50da31bcc29a26f83e997ca709372973dfb550f3eb5ca" => :mountain_lion
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
