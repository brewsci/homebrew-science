class Afra < Formula
  desc "Alignmen-free support values"
  homepage "https://github.com/EvolBioInf/afra"
  # tag "bioinformatics"

  url "https://github.com/EvolBioInf/afra/releases/download/v2.1/afra-v2.1.tar.gz"
  sha256 "e4042de524bc6a979a56fb6f7dba4e163e97ba1047854a385ddebc3ea090d2d3"
  head "https://github.com/EvolBioInf/afra.git"

  bottle do
    cellar :any
    sha256 "fcbfe8aca9af7fd9409aa13aa8409ca9eb060fbb205ad7bedb82e5741f07a321" => :sierra
    sha256 "94d67e2cf81bc3ee51b44a7e63c0579f4a5210be959e2c67663a929da437fb5e" => :el_capitan
    sha256 "31d1a446faaddb4617a84700be5fc3d298eba84ac26f743987df0be818ce118b" => :yosemite
    sha256 "1d4dc43e19ab9565736c41791fa9b653317f9e13e794eb88d233f28401a59d15" => :x86_64_linux
  end

  needs :openmp

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "quartet", shell_output("#{bin}/afra --help 2>&1", 0)
  end
end
