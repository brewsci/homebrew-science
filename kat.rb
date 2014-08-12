require "formula"

class Kat < Formula
  homepage "https://github.com/TGAC/KAT"
  head "https://github.com/TGAC/KAT.git"

  url "https://github.com/TGAC/KAT/releases/download/V1.0.5/kat-1.0.5.tar.gz"
  sha1 "80ba9a0f163978a6351f3e2fd151f372189ac3cd"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gnuplot"
  depends_on "jellyfish-1.1"
  depends_on "seqan"

  def install
    inreplace "configure", "1.1.10", Formula["jellyfish-1.1"].version
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-jellyfish=#{Formula["jellyfish-1.1"].prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/kat --version"
  end
end
