class Uproc < Formula
  desc "Ultra-fast protein sequence classification"
  homepage "http://uproc.gobics.de/"
  url "https://github.com/gobics/uproc/archive/1.2.0.tar.gz"
  sha256 "ceda51784fdce81791e5f669b08a20c415af476ac1ce29a59b596f1181de4f8e"
  head "https://github.com/gobics/uproc.git"
  # doi "10.1093/bioinformatics/btu843"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae84e01f8936f83e8393a6b5ca4eb7ff669c6604ea27b2e5f34b47a92dc44aa4" => :x86_64_linux
  end

  needs :openmp # => :recommended

  depends_on "doxygen" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fvi"
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--with-sysroot=#{HOMEBREW_PREFIX}",
      "--prefix=#{prefix}"

    # Patch for bug related to tar -o option: https://github.com/gobics/uproc/issues/12
    inreplace "libuproc/docs/Makefile", "chozf", "chzf"

    system "make", "install"
  end

  test do
    system "#{bin}/uproc-dna", "--version"
    system "#{bin}/uproc-prot", "--version"
  end
end
