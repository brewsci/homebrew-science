class SnpSites < Formula
  desc "Find SNP sites in a multi FASTA alignment file"
  homepage "https://github.com/sanger-pathogens/snp_sites"
  url "https://github.com/sanger-pathogens/snp_sites/archive/2.0.2.tar.gz"
  sha256 "90f3af114ea1b6b93de840d5f2f1a96a842f17bebaab2c148fa3f91ed24f1cb7"
  head "https://github.com/sanger-pathogens/snp_sites.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    inreplace "src/Makefile.am", "-lrt", "" if OS.mac? # no librt for osx

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
    system "snp_sites"
  end
end
