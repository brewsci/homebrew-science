class Utgb < Formula
  homepage "http://utgenome.org/"
  url "http://maven.utgenome.org/repository/artifact/org/utgenome/utgb-shell/1.5.9/utgb-shell-1.5.9-bin.tar.gz"
  sha256 "4ac23c0df4735983433b8d9ed67cf206df3f12fda39452ad1d356ff3783aa735"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/utgb"
  end

  test do
    system "#{bin}/utgb"
  end
end
