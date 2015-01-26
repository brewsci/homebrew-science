class Pandaseq < Formula
  homepage "https://github.com/neufeld/pandaseq"
  # doi "10.1186/1471-2105-13-31"
  # tag "bioinformatics"

  url "https://github.com/neufeld/pandaseq/archive/v2.8.1.tar.gz"
  sha1 "0f15dd993b8e1e73512d0dc4baccfbbd8a35b5b8"

  head "https://github.com/neufeld/pandaseq.git"

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
