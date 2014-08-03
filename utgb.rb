require 'formula'

class Utgb < Formula
  homepage 'http://utgenome.org/'
  url 'http://maven.utgenome.org/repository/artifact/org/utgenome/utgb-shell/1.5.9/utgb-shell-1.5.9-bin.tar.gz'
  sha1 'fe4aaccfca40df85c495073385f1a5ff904ac893'

  def install
     libexec.install Dir['*']
     bin.install_symlink "#{libexec}/bin/utgb"
  end

  test do
    system "#{bin}/utgb"
  end
end
