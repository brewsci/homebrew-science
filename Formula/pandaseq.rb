class Pandaseq < Formula
  desc "PAired-eND Assembler for DNA sequences"
  homepage "https://github.com/neufeld/pandaseq"
  # doi "10.1186/1471-2105-13-31"
  # tag "bioinformatics"

  url "https://github.com/neufeld/pandaseq/archive/v2.11.tar.gz"
  sha256 "6e3e35d88c95f57d612d559e093656404c1d48c341a8baa6bef7bb0f09fc8f82"

  head "https://github.com/neufeld/pandaseq.git"

  bottle do
    sha256 "ccee1bf80787340ab604c35e25ba6e304c841f8947b3353708ba58cade37ea45" => :sierra
    sha256 "6c18632499898dc6c236ee3c0cac241b93f91d4bfbb39ff5240d44e1e145b036" => :el_capitan
    sha256 "6cc3933dd125da534d7b86c588cdd28ee183d328a6a01e4a33a3692ed5b1d758" => :yosemite
    sha256 "e41b46503c1fe69397d52901a9e39e369f14b05661d7b1969887fee28f45c598" => :x86_64_linux
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
