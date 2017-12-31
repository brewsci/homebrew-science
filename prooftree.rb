class Prooftree < Formula
  desc "Proof tree visualization program"
  homepage "https://askra.de/software/prooftree"
  url "https://askra.de/software/prooftree/releases/prooftree-0.13.tar.gz"
  sha256 "b08949a7f6a1ea04f4f76c53f24c151ea803fc7309d525e0bcf771bc30273f7c"

  bottle do
    cellar :any
    sha256 "aa5262b4e473ac4cd9c4bc6a2b3c2df1fcde36eb1c1526de29a1afc25432f065" => :high_sierra
    sha256 "21059e20ae5f84eea358b535736cd7197f1a30fb4fb9a79cc21a5bc8f1b00dde" => :sierra
    sha256 "224db5456f73cd086a33de8f4a28c2887695bdae7e3c207092f8ae7b36cf364b" => :el_capitan
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
