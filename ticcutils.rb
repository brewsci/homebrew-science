class Ticcutils < Formula
  desc "Tools for the TiCC Software Stack"
  homepage "https://ilk.uvt.nl/ticcutils/"
  url "https://github.com/LanguageMachines/ticcutils/releases/download/v0.15/ticcutils-0.15.tar.gz"
  sha256 "424413e8f49e403edef61d82baf4e885e9d000fab78d774ff5cac6d9831ab630"

  bottle do
    cellar :any
    sha256 "ac93c31e75a639f8bf0d0b6d8d2c6bf10b84f4098fc1ad3934a742817be4e270" => :sierra
    sha256 "6964fb8689e6960204e71c17941c13fb537144ec6bf981ba191ddfdd93c0793a" => :el_capitan
    sha256 "7d5553b92f368c993ad86b05dd15d242c57f3602b7a2b270db4296b84c42566e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2" unless OS.mac?

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
