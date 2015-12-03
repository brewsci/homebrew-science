class SnpSites < Formula
  desc "Find SNP sites in a multi FASTA alignment file"
  homepage "https://github.com/sanger-pathogens/snp_sites"
  url "https://github.com/sanger-pathogens/snp_sites/archive/2.1.0.tar.gz"
  sha256 "775b5383365e3a33959b744115dad6eb966d45fe8232f3997a7ecccc748e9d59"
  head "https://github.com/sanger-pathogens/snp_sites.git"

  bottle do
    cellar :any
    sha256 "fe62d32474f55db5e17f07a0edfd30ac50314adc1216297acbc83c9631f4a0d9" => :el_capitan
    sha256 "68b05b01e3e0e85a9d63bab8a808815a44242124feb24aac2668cb0fc820e5ab" => :yosemite
    sha256 "8fd3e92de61d7ac47b7c0a598e76734dbf426afffe9aa1119d376b8caafc284c" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
    system "snp_sites"
  end
end
