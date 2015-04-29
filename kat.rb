class Kat < Formula
  homepage "https://github.com/TGAC/KAT"
  # tag "bioinformatics"
  url "https://github.com/TGAC/KAT/releases/download/Release-1.0.7/kat-1.0.7.tar.gz"
  sha256 "89f6e55a9462f774028f0047dfa5db1d8a26a9e53e766bec12af3a9d8a720eeb"

  head do
    url "https://github.com/TGAC/KAT.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "2b66feafb04212b405e10fd9d3698bd0001233b9" => :yosemite
    sha1 "a556bf165b6d934d80fb0f6c5d537bdabc0a2449" => :mavericks
    sha1 "878b362d6e7033138611218d716d1140ed4330e3" => :mountain_lion
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
