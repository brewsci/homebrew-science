require 'formula'

class Spades < Formula
  homepage 'http://bioinf.spbau.ru/spades/'
  #doi '10.1089/cmb.2012.0021'
  url 'http://spades.bioinf.spbau.ru/release3.0.0/SPAdes-3.0.0.tar.gz'
  sha1 '87fa1c7c0f3fe71a698dbfdd01d853d131256bcd'

  depends_on 'cmake' => :build

  def install
    mkdir 'src/build' do
      system 'cmake', '..', *std_cmake_args
      system 'make', 'install'
    end
  end

  test do
    system 'spades.py --help'
  end
end
