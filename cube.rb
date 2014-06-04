require "formula"

class Cube < Formula
  homepage "http://apps.fz-juelich.de/scalasca/"
  url "http://apps.fz-juelich.de/scalasca/releases/cube/4.2/dist/cube-4.2.2.tar.gz"
  sha1 "88597c2df082bdc4eeadd6a9dad791b5894c6daa"

  depends_on "qt" => :recommended

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
    system "#{bin}/cube-config --version"
  end
end
