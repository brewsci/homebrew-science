require 'formula'

class Spades < Formula
  homepage 'http://bioinf.spbau.ru/spades/'
  url 'http://spades.bioinf.spbau.ru/release2.5.0/SPAdes-2.5.0.tar.gz'
  sha1 '35a40c617f0202ba3bfb5022a9f703fea0eccb4e'

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
