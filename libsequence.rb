class Libsequence < Formula
  homepage "https://molpopgen.github.io/libsequence/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg316"
  url "https://github.com/molpopgen/libsequence/archive/1.8.4.tar.gz"
  sha1 "1cac19fffad293309c834f3f356023c990422988"
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "a3030e966af22921d8c3180e86e38af3825da183" => :yosemite
    sha1 "dba61184fe4016a653dd9f361f8aec4957340441" => :mavericks
    sha1 "5354fe0f9e6d8d2ed265cf53048ba70d00f9e398" => :mountain_lion
  end

  depends_on "boost" => :build
  depends_on "gsl"

  def install
    ENV.libcxx if MacOS.version < :mavericks

    system "./configure", "--enable-shared=no", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
