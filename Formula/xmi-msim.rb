class XmiMsim < Formula
  desc "Monte Carlo simulation of X-ray fluorescence spectrometers"
  homepage "https://github.com/tschoonj/xmimsim"
  url "https://xmi-msim.tomschoonjans.eu/xmimsim-7.0.tar.gz"
  sha256 "3e970203a56a116fe0b136a857b91b6c4f001cb69b6ac8f68bd865bb7c688542"

  bottle do
    sha256 "fc970f35f3521f29a44dac4d162d518f5769af3a0d7e0b9c9d260df6e240e063" => :high_sierra
    sha256 "e859bd76404db7a6f78b7133f37208448291008c9f63a6f9e239d83ae337dccf" => :sierra
    sha256 "1394481617df2d51badd892a69ee18ff8bbddb898c109a28a3b79d4651a77173" => :el_capitan
    sha256 "853c58b4ebef6a2b824d57b03207092e320cd472db1d6e38d350e01182866c2c" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on :fortran
  depends_on "gsl"
  depends_on "fgsl"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "glib"
  depends_on "hdf5"
  depends_on "xraylib"

  def install
    ENV.deparallelize # fortran modules don't like parallel builds

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gui",
                          "--disable-updater",
                          "--disable-mac-integration",
                          "--disable-libnotify"
    system "make", "install"
  end

  def post_install
    ohai "Generating xmimsimdata.h5 – this may take a while"
    mktemp do
      system bin/"xmimsim-db"
      (share/"xmimsim").install "xmimsimdata.h5"
    end
  end

  test do
    system bin/"xmimsim", "--version"
  end
end
