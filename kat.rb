class Kat < Formula
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  # tag "bioinformatics"
  url "https://github.com/TGAC/KAT/releases/download/Release-1.0.7/kat-1.0.7.tar.gz"
  sha256 "89f6e55a9462f774028f0047dfa5db1d8a26a9e53e766bec12af3a9d8a720eeb"

  bottle do
    cellar :any
    sha256 "e014fb1e638d216189d91ba15bec71db04a253c3cc205e74a86dc6be1ceec6a0" => :yosemite
    sha256 "d953de44bead07fbae63d87a61d2f0444a0fb18eadb8fde8f834b766172e1b61" => :mavericks
    sha256 "e3058870b4be5dba2c7e5ca94925cd5d586afa77327d056839ce74c1e07d9f4a" => :mountain_lion
    sha256 "50eb84f8e80b2eb55f020bf2cdccffac692dadb8c33aa0cabba85b652add7835" => :x86_64_linux
  end

  head do
    url "https://github.com/TGAC/KAT.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gnuplot"
  depends_on "jellyfish-1.1"
  depends_on "seqan"

  def install
    ENV.libstdcxx if ENV.compiler == :clang && MacOS.version >= :mavericks
    system "./autogen.sh" if build.head?

    inreplace "configure", "1.1.11", Formula["jellyfish-1.1"].version
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-jellyfish=#{Formula["jellyfish-1.1"].prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s,
                 shell_output("#{bin}/kat --version")
  end
end
