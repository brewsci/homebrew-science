class Cube < Formula
  desc "Performance report explorer for Scalasca and Score-P"
  homepage "http://apps.fz-juelich.de/scalasca/"
  url "http://apps.fz-juelich.de/scalasca/releases/cube/4.3/dist/cube-4.3.4.tar.gz"
  sha256 "34c55fc5d0c84942c0845a7324d84cde09f3bc1b3fae6a0f9556f7ea0e201065"

  bottle do
    cellar :any
    sha256 "9c9e2d16c2414ac48e69cd1da6e762af48231216dba898166ff137ee972f3c5e" => :sierra
    sha256 "4fdad30075b6d2e0c2eceec05069f980138036985df956940207f878162c9ec0" => :el_capitan
    sha256 "a6adbc6dfc92586c4bc71bc86d12f4d52834b58ae30880c75b055594c348e0f8" => :yosemite
  end

  depends_on "qt5"
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
