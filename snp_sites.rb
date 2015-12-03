class SnpSites < Formula
  desc "Find SNP sites in a multi FASTA alignment file"
  homepage "https://github.com/sanger-pathogens/snp_sites"
  url "https://github.com/sanger-pathogens/snp_sites/archive/2.1.0.tar.gz"
  sha256 "775b5383365e3a33959b744115dad6eb966d45fe8232f3997a7ecccc748e9d59"
  head "https://github.com/sanger-pathogens/snp_sites.git"

  bottle do
    cellar :any
    sha256 "31e19803758c153c4144cc7375a9e497f743a70ec8d334d4459e78ab9c9f729a" => :el_capitan
    sha256 "bfa1c8ebbebd337f7b2506cefa26dcd153ba8c6aeadc3e4cdeae5f4245fcb739" => :yosemite
    sha256 "f8ab966ee80641b5cb8c393cdbee26116bf587f5713e86e24585fbe586daa07a" => :mavericks
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
