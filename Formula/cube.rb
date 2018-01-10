class Cube < Formula
  desc "Performance report explorer for Scalasca and Score-P"
  homepage "https://apps.fz-juelich.de/scalasca/"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.3/dist/cube-4.3.4.tar.gz"
  sha256 "34c55fc5d0c84942c0845a7324d84cde09f3bc1b3fae6a0f9556f7ea0e201065"

  bottle do
    sha256 "f4752655005bcf04a3faebe0173c571e4ca8128fd579db1d4b1eb5967cbbf874" => :sierra
    sha256 "b468ee3261ea60adaa54d628034d413b6157a98230a4c30cbff3d11d23a6b568" => :el_capitan
    sha256 "13c046ba780a2450ab4bf055f5cf70e98a3128ca2e79a55ca364dbc5519bdce9" => :yosemite
  end

  depends_on "qt"
  depends_on "cmake" => :build

  def install
    ENV.deparallelize
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-nocross-compiler-suite=clang",
      "--with-qt-specs=macx-clang",
      'CXXFLAGS="-stdlib=libc++"',
      'LDFLAGS="-stdlib=libc++"'
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/cube-config", "--version"
  end
end
