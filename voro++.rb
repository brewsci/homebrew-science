class Voroxx < Formula
  desc "3D Voronoi cell software library"
  homepage "http://math.lbl.gov/voro++"
  url "http://math.lbl.gov/voro++/download/dir/voro++-0.4.6.tar.gz"
  sha256 "ef7970071ee2ce3800daa8723649ca069dc4c71cc25f0f7d22552387f3ea437e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2109a6a57ad40d0575f2c6e6c96ba9e6da212d6555199e31fb82bbdc64efebc8" => :sierra
    sha256 "05fe4c7cbb294617e6ff928e3e2f703b60009d0b1937e0d87518bfda30b6c0e0" => :el_capitan
    sha256 "ee5cf53ab32d84e795f3850b39121b40c1eb37a453153daf6905b826887031c2" => :yosemite
  end

  # tag "math"
  # doi "10.1063/1.3215722"

  depends_on "patchelf" unless OS.mac?

  def install
    system "make", "install", "PREFIX=#{prefix}", "CFLAGS=#{ENV.cflags} -fPIC"
    pkgshare.install("examples")
    mv prefix / "man", share / "man"
  end

  def caveats
    <<-EOS.undent
    Example scripts are installed here:
      #{HOMEBREW_PREFIX}/share/voro++/examples
    EOS
  end

  test do
    system "#{bin}/voro++", "-h"
  end
end
