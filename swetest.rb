require "formula"

class Swetest < Formula
  homepage "http://www.astro.com/swisseph/"
  url "http://www.astro.com/ftp/swisseph/swe_unix_src_2.00.00.tar.gz"
  sha1 "db521595e097937ba8ca8bbc8405a6410626685a"

  resource "seasnam" do
    url "ftp://ftp.astro.com/pub/swisseph/ephe/seasnam.txt"
    sha1 "e28fd6b633cce2b5c022e940c652bee9be11224e"
  end

  resource "sefstars" do
    url "ftp://ftp.astro.com/pub/swisseph/ephe/sefstars.txt"
    sha1 "5837ba3c07ffde6ea37ad3c6083693359f8f7c2c"
  end

  resource "seas" do
    url "ftp://ftp.astro.com/pub/swisseph/ephe/seas_18.se1"
    sha1 "35b39c2f09e7d9ae55c2824e37000bc9ca8aa92f"
  end

  resource "semo" do
    url "ftp://ftp.astro.com/pub/swisseph/ephe/semo_18.se1"
    sha1 "2386cef39987c88db5b61273356f3cac6bf766ae"
  end

  resource "sepl" do
    url "ftp://ftp.astro.com/pub/swisseph/ephe/sepl_18.se1"
    sha1 "f92d86afa1b3dce22acf7f0ee34f7b4382addd65"
  end

  def install
    # hack away the epehemeris path, as the default won't do.
    system "echo \"#define SE_EPHE_PATH \\\".:#{share}\\\"\" >> src/swephexp.h"

    # we have to clean because the archive already has a linux compiled library
    system "make -C src clean"
    system "make -C src swetest"

    bin.install "src/swetest"

    # install ephemeris
    share.install resource("seasnam")
    share.install resource("sefstars")
    share.install resource("seas")
    share.install resource("semo")
    share.install resource("sepl")
  end

  test do
    system "#{bin}/swetest -b12.10.1875 -ut04:45:00 -eswe -geopos52.2851905,-1.5200789"
  end
end
