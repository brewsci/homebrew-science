class SnpSites < Formula
  desc "Find SNP sites in a multi FASTA alignment file"
  homepage "https://github.com/sanger-pathogens/snp-sites"
  url "https://github.com/sanger-pathogens/snp-sites/archive/2.2.0.tar.gz"
  sha256 "6ee85a175871218d40ba25677814b1ec7959bfa16435f497f8167c06bce2a6c6"
  head "https://github.com/sanger-pathogens/snp-sites.git"
  # doi "10.1101/038190"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "fc578b9dc761947865807d14c58adfbfa53c2c25924c37be95459df5bbd26ed3" => :el_capitan
    sha256 "1dec6728adb00f284429b636b6bae8575a3437b4812b012b74f3225bb8eb09bd" => :yosemite
    sha256 "1f53e480cce81b4cd405de5196d7297b67765757ac0b896c1622a7e428f7debc" => :mavericks
    sha256 "f8e5d6646175a8c7fe09e23868c4a23f9020c8c3d36140a468e20106a21a55fc" => :x86_64_linux
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
    system "snp-sites"
  end
end
