class Pandaseq < Formula
  desc "PAired-eND Assembler for DNA sequences"
  homepage "https://github.com/neufeld/pandaseq"
  # doi "10.1186/1471-2105-13-31"
  # tag "bioinformatics"

  url "https://github.com/neufeld/pandaseq/archive/v2.10.tar.gz"
  sha256 "93cd34fc26a7357e14e386b9c9ba9b28361cf4da7cf62562dc8501e220f9a561"

  head "https://github.com/neufeld/pandaseq.git"

  bottle do
    sha256 "86a784352c9eed0019160559fca1fd8e04a65375b5ca3496ba46140cecd4eaa3" => :el_capitan
    sha256 "4483d73f7dcc06bed9fd3a7e1c917dfdd8417c360cc4646235f4a54169869749" => :yosemite
    sha256 "d64c18e007b5b89440cb678c93f6ac386e0195b51c162cc63bae857cc8b31c25" => :mavericks
    sha256 "83fbe77de618b91c6fd2a7efdbe8b52478c3e1a48f87881ec9118dcee7ffcba9" => :x86_64_linux
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
