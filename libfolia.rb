class Libfolia < Formula
  desc "XML annotation format for linguistically annotated language resources"
  homepage "https://proycon.github.io/folia/"
  url "http://software.ticc.uvt.nl/libfolia-0.13.tar.gz"
  sha256 "a9fc9e475bb79629dc014cf7a78af64486c0f1bb902821ba2bb36c38c77a5d24"

  bottle do
    cellar :any
    sha256 "5259f25027ac5f434b58d26b40ab0a1d79c1c623238ab5390435ae0b86813263" => :yosemite
    sha256 "a5e58e875d353398800fd2c3f6efa824a1af4b8aea735225ca1f981f9bc93327" => :mavericks
    sha256 "245d72db8e3c2141ebc37d68112b0d24d85b071d46ba1df2a20dff5c48392bb2" => :mountain_lion
  end

  option "without-check", "skip build-time checks (not recommended)"

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "ticcutils"
  depends_on "libxslt"
  depends_on "libxml2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
