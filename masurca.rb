require 'formula'

class Masurca < Formula
  homepage 'http://www.genome.umd.edu/masurca.html'
  url 'ftp://ftp.genome.umd.edu/pub/MaSuRCA/MaSuRCA-2.0.4.tar.gz'
  sha1 '7e36afd82bd581566d46fd4dedd7ffc6cd751fb2'

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
