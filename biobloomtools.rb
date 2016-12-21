class Biobloomtools < Formula
  desc "BioBloom Tools (BBT): Bloom filter for bioinformatics"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  # doi "10.1093/bioinformatics/btu558"
  # tag "bioinformatics"

  url "https://github.com/bcgsc/biobloom/releases/download/2.0.13/biobloomtools-2.0.13.tar.gz"
  sha256 "2aa30b1641b58122f93fa3b6649fbe795db835b34c26f33bfed45975cba254a9"

  bottle do
    cellar :any
    sha256 "68c125cd6e5e02b1eb2aa79e40ca6e82c2bb2ed8764f6d11445463fb460032d4" => :yosemite
    sha256 "fcf60aca3e3326a1a422535190de56d2c8dc1d26af1cd1320f642485db7fe64c" => :mavericks
    sha256 "0730a556dc8b5cbc99f653ab8eeb4de922875ca3b23113b9103cf42406ec6a43" => :mountain_lion
    sha256 "96ecc7bc17de7cb5e33b68ba00eadcc249106714675190cd819fa47173f0557c" => :x86_64_linux
  end

  head do
    url "https://github.com/bcgsc/biobloom.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "boost" => :build
  depends_on "gcc"

  needs :openmp

  def install
    system "./autogen.sh" if build.head?
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/biobloommaker", "--version"
    system "#{bin}/biobloomcategorizer", "--version"
  end
end
