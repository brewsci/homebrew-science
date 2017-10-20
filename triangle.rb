class Triangle < Formula
  homepage "https://www.cs.cmu.edu/~quake/triangle.html"
  url "http://www.netlib.org/voronoi/triangle.zip"
  version "1.6"
  sha256 "1766327add038495fa3499e9b7cc642179229750f7201b94f8e1b7bee76f8480"

  depends_on :x11

  def install
    inreplace "makefile" do |s|
      s.gsub! "-DLINUX", ""
      s.remove_make_var! "CC"
    end

    system "make"
    system "make", "trilibrary"
    system "ar", "r", "libtriangle.a", "triangle.o"

    bin.install %w[triangle showme]
    lib.install "libtriangle.a"
    include.install "triangle.h"
    doc.install %w[README A.poly tricall.c]
  end

  def caveats; <<-EOS.undent
      Triangle is distributed under a license that places restrictions on how
      the code or library may be used in commercial products.  See the README
      file for more info:
          #{prefix}/README
    EOS
  end
end
