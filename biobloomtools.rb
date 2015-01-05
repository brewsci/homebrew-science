class Biobloomtools < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  #doi "10.1093/bioinformatics/btu558"
  #tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/releases/2.0.6/biobloomtools-2.0.6.tar.gz"
  sha1 "8eb6fed35104b32bb12a5ee3fdb9d6ca9b752aa1"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "715218ca44ec4a5e572ebaa71a7e5f7348e6ba7c" => :yosemite
    sha1 "2eb4b97895569fa83ba54dec06d35aaf90552009" => :mavericks
    sha1 "7d69cd24a383009b85046bf9cb2af86e8f568489" => :mountain_lion
  end

  depends_on "boost" => :build

  fails_with :clang do
    build 600
    cause "error: reference to 'shared_ptr' is ambiguous"
  end

  def install
    # Fix error: 'citycrc.h' file not found
    inreplace "Common/city.cc", "#ifdef __SSE4_2__", "#if 0"

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
