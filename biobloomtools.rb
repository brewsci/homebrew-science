class Biobloomtools < Formula
  desc "BioBloom Tools (BBT): Bloom filter for bioinformatics"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  # doi "10.1093/bioinformatics/btu558"
  # tag "bioinformatics"

  url "https://github.com/bcgsc/biobloom/releases/download/2.0.12/biobloomtools-2.0.12.tar.gz"
  sha256 "34314242d44f1891c4e1cae214ee1b151b8dea1c34760dce2f76f0d3764098f4"

  head do
    url "https://github.com/bcgsc/biobloom.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "715218ca44ec4a5e572ebaa71a7e5f7348e6ba7c" => :yosemite
    sha1 "2eb4b97895569fa83ba54dec06d35aaf90552009" => :mavericks
    sha1 "7d69cd24a383009b85046bf9cb2af86e8f568489" => :mountain_lion
  end

  depends_on "boost" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
    doc.install "README.html", "README.md"
  end

  test do
    system "#{bin}/biobloommaker", "--version"
    system "#{bin}/biobloomcategorizer", "--version"
  end
end
