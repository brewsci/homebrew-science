require 'formula'

class Spades < Formula
  homepage 'http://bioinf.spbau.ru/spades/'
  url 'http://spades.bioinf.spbau.ru/release2.4.0/SPAdes-2.4.0.tar.gz'
  sha1 '25f9d09d08f542204f4b70ed0caac5c62b51353c'

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
