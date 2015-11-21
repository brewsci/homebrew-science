class Timbl < Formula
  desc "Memory-based learning algorithms"
  homepage "http://ilk.uvt.nl/timbl/"
  url "http://software.ticc.uvt.nl/timbl-6.4.6.tar.gz"
  sha256 "8aeb09283a3389db9b3b576b6f0632f84841facc85cad516bb57e3ec070737b4"
  revision 1

  bottle do
    cellar :any
    sha1 "7188843d1ad3fee331f6508bfae96ecc68e563ec" => :yosemite
    sha1 "2def0ce56128f15548948e8487f184377d7d7492" => :mavericks
    sha1 "ae935f458395343eaeab276825ca9a5dfdf5e95e" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "ticcutils"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
