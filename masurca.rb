require 'formula'

class Masurca < Formula
  homepage 'http://www.genome.umd.edu/masurca.html'
  url 'ftp://ftp.genome.umd.edu/pub/MaSuRCA/MaSuRCA-2.0.0.tar.gz'
  sha1 '91ef80b34206e8d3c3d93a1a88f058ded8c1dfb5'

  keg_only 'MaSuRCA conflicts with jellyfish.'

  def install
    ENV.j1
    ENV['DEST'] = prefix
    system './install.sh'
  end

  test do
    system "#{bin}/runSRCA.pl"
  end
end
