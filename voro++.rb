class Voroxx < Formula
  desc "3D Voronoi cell software library"
  homepage "http://math.lbl.gov/voro++"
  url "http://math.lbl.gov/voro++/download/dir/voro++-0.4.6.tar.gz"
  sha256 "ef7970071ee2ce3800daa8723649ca069dc4c71cc25f0f7d22552387f3ea437e"
  head "https://codeforge.lbl.gov/anonscm/voro/trunk", :using => :svn
  # tag "math"
  # doi "10.1063/1.3215722"

  def install
    system "make", "install", "PREFIX=#{prefix}"
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
