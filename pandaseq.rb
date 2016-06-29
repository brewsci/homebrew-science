class Pandaseq < Formula
  desc "PAired-eND Assembler for DNA sequences"
  homepage "https://github.com/neufeld/pandaseq"
  # doi "10.1186/1471-2105-13-31"
  # tag "bioinformatics"

  url "https://github.com/neufeld/pandaseq/archive/v2.10.tar.gz"
  sha256 "93cd34fc26a7357e14e386b9c9ba9b28361cf4da7cf62562dc8501e220f9a561"

  head "https://github.com/neufeld/pandaseq.git"

  bottle do
    sha256 "b8074161853044a591afc97ee5a99110c2a1208fd6bb93ddc561319bdf7a7598" => :yosemite
    sha256 "c515d863dc15f1ef89c6fdd4a861fa0314a062cb092881deedff33250db1aec7" => :mavericks
    sha256 "1c6d0cc30417723362c8b8a0a40f3710f7de64cac04ee8a8026561a8282b12a6" => :mountain_lion
    sha256 "41d6205243f70ea83d77c93beea2e573364346e72fdd3bd638cdb28fe6eb1ddc" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "zlib" unless OS.mac?

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
    assert_match version.to_s, shell_output("#{bin}/pandaseq -v 2>&1", 1)
  end
end
