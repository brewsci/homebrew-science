class Ccfits < Formula
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.5.tar.gz"
  sha256 "938ecd25239e65f519b8d2b50702416edc723de5f0a5387cceea8c4004a44740"

  bottle do
    cellar :any
    sha256 "339ebabbdc656d5de608bf2ae26235e19715f14003078daa9fd135ee56f76f42" => :high_sierra
    sha256 "d57f9358f8e87b2f27f73a5423fbbe54ad3d45e95e240eaefe4f9398ad42d8e8" => :sierra
    sha256 "1f5b05bfb35f13d712023da7a4a86091b70d3f9a3593c433208fda67b54b10b3" => :el_capitan
    sha256 "49649b730f406133c22ab2990f06393a70ff2688ac48d56b2c1e48e103ab4270" => :x86_64_linux
  end

  option "without-check", "Disable build-time checking (not recommended)"

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
