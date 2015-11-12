class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "http://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.30/Healpix_3.30_2015Oct08.tar.gz"
  version "3.30"
  sha256 "efcc8ff9775f393bd3e7e9d36202126e34e5c762ee568495a728329fa6650bfb"

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
end
