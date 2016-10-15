class Cube < Formula
  homepage "http://apps.fz-juelich.de/scalasca/"
  url "http://apps.fz-juelich.de/scalasca/releases/cube/4.2/dist/cube-4.2.2.tar.gz"
  sha256 "67a7e2b3cf4927620fc4e987d6fae76b753a74303b3c9d30ea2e0937e64ae82a"

  bottle do
    cellar :any
    sha256 "9c9e2d16c2414ac48e69cd1da6e762af48231216dba898166ff137ee972f3c5e" => :sierra
    sha256 "4fdad30075b6d2e0c2eceec05069f980138036985df956940207f878162c9ec0" => :el_capitan
    sha256 "a6adbc6dfc92586c4bc71bc86d12f4d52834b58ae30880c75b055594c348e0f8" => :yosemite
  end

  # qt is currently not available on 10.12
  depends_on "qt" => :recommended if MacOS.version < :sierra

  fails_with :clang do
    cause <<-EOS.undent
      Undefined symbols for architecture x86_64:
      "cube::Cube::def_mirror(std::string const&)", referenced from:
      MainWidget::readFile(QString) in cube-MainWidget.o
    EOS
  end if build.with? "qt"

  def install
    ENV.deparallelize

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/cube-config", "--version"
  end
end
