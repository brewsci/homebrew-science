class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "http://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.31/Healpix_3.31_2016Aug26.tar.gz"
  version "3.31"
  sha256 "ddf437442b6d5ae7d75c9afaafc4ec43921f903c976e25db3c5ed5185a181542"

  bottle do
    cellar :any
    sha256 "2e1fd73dea22bec133fdae9611b87620dd4620998e798578e385400ef76c5d2b" => :el_capitan
    sha256 "a19acb47d7c6f83d19828b99fe190da5309cf148113f6ccea351f7fcb5a627b5" => :yosemite
    sha256 "ba491c231f7e086b2d3a59d391687abbe2052f6f87b788ae3447b74dfa01ba6d" => :mavericks
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
