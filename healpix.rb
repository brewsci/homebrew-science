class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov/"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.31/Healpix_3.31_2016Aug26.tar.gz"
  version "3.31"
  sha256 "ddf437442b6d5ae7d75c9afaafc4ec43921f903c976e25db3c5ed5185a181542"

  bottle do
    cellar :any
    sha256 "704b58888fc0cef220f3ff38a18d5d48625c95dc1666e69cf87d7770a9527739" => :sierra
    sha256 "255c7bd9ef31f1ffbbd79dccaa9055e64c42e287faea57a1922f4973b49940a8" => :el_capitan
    sha256 "103d92efc27fde3cdeef9a6b01e7693182082d126bb352009dfeec336736df67" => :yosemite
    sha256 "2fcb7b8a7df2e54b6e1cf4430fffda652469418f303b114800674a774a685fb8" => :x86_64_linux
  end

  depends_on "cfitsio"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    configure_args = %W[  --disable-dependency-tracking
                          --disable-silent-rules
                          --prefix=#{prefix}  ]

    cd "src/C/autotools" do
      system "autoreconf", "--install"
      system "./configure", *configure_args
      system "make", "install"
    end

    ENV.append_to_cflags "-DENABLE_FITSIO"
    cd "src/cxx/autotools" do
      system "echo", "\"AUTOMAKE_OPTIONS = subdir-objects\" >> Makefile.am"
      system "autoreconf", "--install"
      system "./configure", *configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<-EOS
      #include <math.h>
      #include <stdio.h>
      #include "chealpix.h"

      int main(void) {
        long   nside, npix, pp, ns1;
        nside = 1024;

        for (pp = 0; pp < 14; pp++) {
          nside = pow(2, pp);
          npix = nside2npix(nside);
          ns1  = npix2nside(npix);
        }
      };
    EOS
    # Build step
    system ENV.cxx, "-o", "test", "test.cxx", "-L#{lib}", "-lchealpix"
    system "./test"
  end
end
