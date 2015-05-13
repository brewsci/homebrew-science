class Swetest < Formula
  homepage "http://www.astro.com/swisseph/"
  url "http://www.astro.com/ftp/swisseph/swe_unix_src_2.01.00.tar.gz"
  sha256 "bd601d5e7982926a291eb6ed50ef846f85412411ebdc2a7ae67dbd200f952289"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "4c8d6ac3424b55faa73f1ff35f8abd95cd7497aa9e8740c92d902af17ba6e2e1" => :yosemite
    sha256 "d1fb07a32fe088ce708d31770ba9bc506b93cc3f03be9c915a2b414f0d98ef1b" => :mavericks
    sha256 "2e10f551bec64b7e2437fc4a1da2d4c7e62001bbdd663b407b5b25ba60651ccb" => :mountain_lion
  end

  resource "seasnam" do
    url "http://www.astro.com/ftp/swisseph/ephe/seasnam.txt"
    sha256 "788fed3698bab62e53a9d519aed511566936b5577b3309251dba12da131c214b"
  end

  resource "sefstars" do
    url "http://www.astro.com/ftp/swisseph/ephe/sefstars.txt"
    sha256 "007d98f1d829ffdbd380025eaa383b4c63fc2d2ff2715d7e2586de38ce319de1"
  end

  resource "seas" do
    url "http://www.astro.com/ftp/swisseph/ephe/seas_18.se1"
    sha256 "0afe3f94769b6718082411c2c4fb06bf9d1aaa6c0bc1bad8f8b8725421ef8748"
  end

  resource "semo" do
    url "http://www.astro.com/ftp/swisseph/ephe/semo_18.se1"
    sha256 "ecfa54dbf5bc0b5a9bc3e04ed28629a821e98625eacae38f4070593bba0e2980"
  end

  resource "sepl" do
    url "http://www.astro.com/ftp/swisseph/ephe/sepl_18.se1"
    sha256 "0b7e416e3c1be9e6a0dd1d711dae7f7685793a0e7df13f76363a493dc27b6ea1"
  end

  def install
    # Hack away the epehemeris path, as the default won't do.
    open("src/swephexp.h", "a") do |file|
      file.write "#define SE_EPHE_PATH \".:#{share}\""
    end

    # we have to clean because the archive already has a linux compiled library
    system "make", "-C", "src", "clean"
    system "make", "-C", "src", "swetest"

    bin.install "src/swetest"

    # install ephemeris
    share.install resource("seasnam")
    share.install resource("sefstars")
    share.install resource("seas")
    share.install resource("semo")
    share.install resource("sepl")
  end

  test do
    system bin/"swetest", "-b12.10.1875", "-ut04:45:00", "-eswe", "-geopos52.2851905,-1.5200789"
  end
end
