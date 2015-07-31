class Swetest < Formula
  homepage "http://www.astro.com/swisseph/"
  url "http://www.astro.com/ftp/swisseph/swe_unix_src_2.01.00.tar.gz"
  sha256 "bd601d5e7982926a291eb6ed50ef846f85412411ebdc2a7ae67dbd200f952289"

  bottle do
    revision 1
    sha256 "976eac94471025db6abbe500edb9a98eb17e903632794620a8a97a2ba6059bf5" => :yosemite
    sha256 "5fac3c730b4c69804fb54198a513067c83a51d080a5d8e6e243e3169b8e10d9c" => :mavericks
    sha256 "705b0a2d4d7c3fbfaccad6bcb6137eafe4360464b028ebe0eb4aab8ca945bb1f" => :mountain_lion
  end

  resource "seasnam" do
    url "http://www.astro.com/ftp/swisseph/ephe/seasnam.txt"
    sha256 "88f91ac63f3ead524dc44eec9923fe0c7de73eb6c72ed9ed38575c626f026efa"
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
