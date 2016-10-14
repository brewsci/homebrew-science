class Cube < Formula
  homepage "http://apps.fz-juelich.de/scalasca/"
  url "http://apps.fz-juelich.de/scalasca/releases/cube/4.2/dist/cube-4.2.2.tar.gz"
  sha256 "67a7e2b3cf4927620fc4e987d6fae76b753a74303b3c9d30ea2e0937e64ae82a"

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
