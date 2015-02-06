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
    sha1 "5db3089b42e70876c4b689bd5198dad98206e84b" => :yosemite
    sha1 "23f77e827d036c71577871528472c09d0e445424" => :mavericks
    sha1 "51eebcbc2438cada227cf9c1827728ad1821b6c7" => :mountain_lion
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
