class Ucto < Formula
  desc "Unicode tokenizer"
  homepage "http://ilk.uvt.nl/ucto/"
  url "http://software.ticc.uvt.nl/ucto-0.8.0.tar.gz"
  sha256 "d3de9886aac95b5eaa48c45a6f8e69e3bb0c350f1d827987e802f4a2ccbcd0bc"
  revision 1

  bottle do
    sha256 "b6ef7f2f3927c57be81fa609a655a66dbe4d5846655b82b219aa3597429ed85b" => :yosemite
    sha256 "cb0d3f6beb8b20ea718ef9d6727f07dce46584fab879c5df4619909246c354b5" => :mavericks
    sha256 "54d366bf282a357f72b2bdc106bd353dc6a071d7697183905b8e803f8feb2c54" => :mountain_lion
  end

  option "without-check", "skip build-time checks (not recommended)"

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libfolia"
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
