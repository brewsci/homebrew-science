require 'formula'

class SnpSites < Formula
  homepage 'https://github.com/sanger-pathogens/snp_sites'
  url 'https://github.com/sanger-pathogens/snp_sites/archive/1.5.0.tar.gz'
  sha1 '3b9e6dd25a6c4dd75631f95f593b18697115e110'
  head 'https://github.com/sanger-pathogens/snp_sites.git'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    inreplace "src/Makefile.am", "-lrt", "" if OS.mac? # no librt for osx

    system "autoreconf -i"
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}"

    system "make", "install"

    ln_s "#{bin}/snp-sites", "#{bin}/snp_sites"
    share.install "tests/data"
  end

  test do
    system "snp_sites"
  end
end
