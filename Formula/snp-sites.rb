class SnpSites < Formula
  desc "Find SNP sites in a multi FASTA alignment file"
  homepage "https://github.com/sanger-pathogens/snp-sites"
  # doi "10.1101/038190"
  # tag "bioinformatics"

  url "https://github.com/sanger-pathogens/snp-sites/archive/2.3.2.tar.gz"
  sha256 "7a77af914b0baa425ccacedf2e4fbb2cac984fe671f3d8c07d98d3596202ed89"
  head "https://github.com/sanger-pathogens/snp-sites.git"

  bottle do
    cellar :any
    sha256 "2a1fc64def2288b12ebd1ce7a9ce5265a9cd0ad900ccf6230a00edee4e7a37b4" => :sierra
    sha256 "c7350da7fd4fd2eb59e983de0927e3cd14a77968410f5584171f0fae570609ef" => :el_capitan
    sha256 "8b0dcb2e7fefd753f4eb11df8a117725a7a3aed8e1694ca13de19121bf296b64" => :yosemite
    sha256 "d4fba5117af1976be010b60a810ae39b59d6df53921a3ccdf31b190bfd2622ae" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check" => :build

  def install
    system "autoreconf", "-i"
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}"

    system "make", "install"

    ln_s "#{bin}/snp-sites", "#{bin}/snp_sites"
    pkgshare.install "tests/data"
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/snp-sites -V 2>&1", 0)
  end
end
