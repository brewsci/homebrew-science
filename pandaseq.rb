class Pandaseq < Formula
  homepage "https://github.com/neufeld/pandaseq"
  # doi "10.1186/1471-2105-13-31"
  # tag "bioinformatics"

  url "https://github.com/neufeld/pandaseq/archive/v2.8.1.tar.gz"
  sha256 "9f90fc178de605d0eb931d2493872e0f61a0e5d97b73c539f8152b331996327e"

  head "https://github.com/neufeld/pandaseq.git"

  bottle do
    sha256 "b8074161853044a591afc97ee5a99110c2a1208fd6bb93ddc561319bdf7a7598" => :yosemite
    sha256 "c515d863dc15f1ef89c6fdd4a861fa0314a062cb092881deedff33250db1aec7" => :mavericks
    sha256 "1c6d0cc30417723362c8b8a0a40f3710f7de64cac04ee8a8026561a8282b12a6" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pandaseq -h 2>&1 |grep pandaseq"
  end
end
