class Prooftree < Formula
  desc "Proof tree visualization program"
  homepage "https://askra.de/software/prooftree"
  url "https://askra.de/software/prooftree/releases/prooftree-0.13.tar.gz"
  sha256 "b08949a7f6a1ea04f4f76c53f24c151ea803fc7309d525e0bcf771bc30273f7c"

  bottle do
    cellar :any
    sha256 "564387d65bcff022dfc76581bfecc91bc63a7a85a342bf71b8b580980040676d" => :el_capitan
    sha256 "0a48e2ac01ca8fcad293a36928a2a7cd2111aa767ba30f49ea8e41ad786fed16" => :yosemite
    sha256 "b9d31069363c481c3fb5c3bbf885ecb92e39b71e8ee288b96c28e8ed3d36f832" => :mavericks
  end

  depends_on "lablgtk"
  depends_on "ocaml" => :build

  def install
    system "./configure", "--prefix", prefix
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/prooftree", "--help"
  end
end
