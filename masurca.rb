require 'formula'

class Masurca < Formula
  homepage 'http://www.genome.umd.edu/masurca.html'
  #doi "10.1093/bioinformatics/btt476"
  url 'ftp://ftp.genome.umd.edu/pub/MaSuRCA/MaSuRCA-2.0.4.tar.gz'
  sha1 '7e36afd82bd581566d46fd4dedd7ffc6cd751fb2'

  keg_only 'MaSuRCA conflicts with jellyfish.'

  depends_on "pkg-config"

  def install
    raise "MaSuRCA fails to build on Mac OS. See https://github.com/Homebrew/homebrew-science/issues/344" if OS.mac?
    ENV.j1
    ENV['DEST'] = prefix
    system './install.sh'
  end

  test do
    system "#{bin}/runSRCA.pl"
  end
end
