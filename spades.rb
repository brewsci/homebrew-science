require 'formula'

class Spades < Formula
  homepage 'http://bioinf.spbau.ru/spades/'
  #doi '10.1089/cmb.2012.0021'
  url 'http://spades.bioinf.spbau.ru/release3.1.0/SPAdes-3.1.0.tar.gz'
  sha1 '231b5550507cc2e2bd11d69e4a349025cfbe8ac7'

  depends_on 'cmake' => :build

  def install
    mkdir 'src/build' do
      system 'cmake', '..', *std_cmake_args
      system 'make', 'install'
    end
  end

  test do
    system 'spades.py --test'
  end
end
