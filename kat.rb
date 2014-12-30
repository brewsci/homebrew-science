class Kat < Formula
  homepage "https://github.com/TGAC/KAT"
  head "https://github.com/TGAC/KAT.git"
  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "2b66feafb04212b405e10fd9d3698bd0001233b9" => :yosemite
    sha1 "a556bf165b6d934d80fb0f6c5d537bdabc0a2449" => :mavericks
    sha1 "878b362d6e7033138611218d716d1140ed4330e3" => :mountain_lion
  end

  #tag "bioinformatics"

  url "https://github.com/TGAC/KAT/releases/download/Release-1.0.6/kat-1.0.6.tar.gz"
  sha1 "845f59aebff01730247b6c8ecf8b1cf2d642b5da"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gnuplot"
  depends_on "jellyfish-1.1"
  depends_on "seqan"

  def install
    ENV.libstdcxx if ENV.compiler == :clang && MacOS.version >= :mavericks
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
    system "#{bin}/kat", "--version"
  end
end
