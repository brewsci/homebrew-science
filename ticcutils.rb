class Ticcutils < Formula
  desc "Tools for the TiCC Software Stack"
  homepage "https://ilk.uvt.nl/ticcutils/"
  url "https://github.com/LanguageMachines/ticcutils/releases/download/v0.17/ticcutils-0.17.tar.gz"
  sha256 "4e5ed6b66a8595f4bdb75c46458723c6a8001a570ff47c068ea4e1ff1517c8a1"

  bottle do
    cellar :any
    sha256 "ac93c31e75a639f8bf0d0b6d8d2c6bf10b84f4098fc1ad3934a742817be4e270" => :sierra
    sha256 "6964fb8689e6960204e71c17941c13fb537144ec6bf981ba191ddfdd93c0793a" => :el_capitan
    sha256 "7d5553b92f368c993ad86b05dd15d242c57f3602b7a2b270db4296b84c42566e" => :yosemite
    sha256 "6defc0c5834c92f245a3eaf86751544c7b0d56a1ee62a9ba066ae382e800334c" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"

  unless OS.mac?
    depends_on "bzip2"
    depends_on "libxml2"
    depends_on "zlib"
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"
  end
end
