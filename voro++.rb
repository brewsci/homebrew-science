class Voroxx < Formula
  homepage "http://math.lbl.gov/voro++"
  url "http://math.lbl.gov/voro++/download/dir/voro++-0.4.6.tar.gz"
  sha256 "ef7970071ee2ce3800daa8723649ca069dc4c71cc25f0f7d22552387f3ea437e"
  head "https://codeforge.lbl.gov/anonscm/voro/trunk", :using => :svn

  def install
    system "make", "install", "PREFIX=#{prefix}"
    (share / "voro++").install("examples")
    mv prefix / "man", share / "man"
  end

  test do
    system "voro++", "-h"
  end

  def caveats
    <<-EOS.undent
    Example scripts are installed here:
      #{HOMEBREW_PREFIX}/share/voro++/examples
    EOS
  end
end
