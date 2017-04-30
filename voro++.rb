class Voroxx < Formula
  desc "3D Voronoi cell software library"
  homepage "http://math.lbl.gov/voro++"
  url "http://math.lbl.gov/voro++/download/dir/voro++-0.4.6.tar.gz"
  sha256 "ef7970071ee2ce3800daa8723649ca069dc4c71cc25f0f7d22552387f3ea437e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "7e392a773ec9a1b57db1f1ca6ab507275e67b9915a57406061c8596828720bc6" => :sierra
    sha256 "ddc5e74203da094994e301bfb799a419b6683b6818943b90fe8e9acbb1cc199b" => :el_capitan
    sha256 "8790ee943b4ea54d0847938f3cf0ef746589c55dfcea6e78cd9432d38a036ad3" => :yosemite
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
