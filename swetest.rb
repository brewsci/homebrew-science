class Swetest < Formula
  homepage "https://www.astro.com/swisseph/"
  url "https://www.astro.com/ftp/swisseph/swe_unix_src_2.06.tar.gz"
  sha256 "e2e3ac2cee53b38865b071f6d86ae0a05e0f608fbf3acc569104589d5a23576f"

  bottle do
    sha256 "9f4505f1cad7674e45f4e01f7a8897ae82f876cd99e93519a9c11f424c598e3e" => :sierra
    sha256 "0a0448ef411bf683adcb425a8abfae4c2d5c10ef788c4ee6b6835672313490e5" => :el_capitan
    sha256 "0224a908fb30d63663c06e73be5b2040802982c0c07005adf1b955664e60856e" => :yosemite
    sha256 "c40f2e402aa625e66eeffb520c079bb2313f330e61404a592fa08977eada5782" => :x86_64_linux
  end

  resource "seasnam" do
    url "https://www.astro.com/ftp/swisseph/ephe/seasnam.txt"
    sha256 "6388016a052de32673ab82d797be143627772d227b27d4ebb2cc8079b82ee471"
  end
  resource "sefstars" do
    url "https://www.astro.com/ftp/swisseph/ephe/sefstars.txt"
    sha256 "3d69f4ea6d8b8be1cda81dd6a3a410ec88bb938010af6c1123180987776f69a8"
  end
  resource "seas" do
    url "https://www.astro.com/ftp/swisseph/ephe/seas_18.se1"
    sha256 "0afe3f94769b6718082411c2c4fb06bf9d1aaa6c0bc1bad8f8b8725421ef8748"
  end
  resource "semo" do
    url "https://www.astro.com/ftp/swisseph/ephe/semo_18.se1"
    sha256 "ecfa54dbf5bc0b5a9bc3e04ed28629a821e98625eacae38f4070593bba0e2980"
  end
  resource "sepl" do
    url "https://www.astro.com/ftp/swisseph/ephe/sepl_18.se1"
    sha256 "0b7e416e3c1be9e6a0dd1d711dae7f7685793a0e7df13f76363a493dc27b6ea1"
  end

  def install
    # Hack away the ephemeris path, as the default won't do.
    open("src/swephexp.h", "a") do |file|
      file.write "#define SE_EPHE_PATH \".:#{libexec}\""
    end

    # we have to clean because the archive already has a linux compiled library
    system "make", "-C", "src", "clean"
    system "make", "-C", "src", "swetest"

    bin.install "src/swetest"

    # install ephemeris
    libexec.install resource("seasnam")
    libexec.install resource("sefstars")
    libexec.install resource("seas")
    libexec.install resource("semo")
    libexec.install resource("sepl")
  end

  test do
    system bin/"swetest", "-b12.10.1875", "-ut04:45:00", "-eswe", "-geopos52.2851905,-1.5200789"
  end
end
