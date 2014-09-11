require 'formula'

class Spades < Formula
  homepage "http://bioinf.spbau.ru/spades/"
  #tag "bioinformatics"
  #doi "10.1089/cmb.2012.0021"
  url "http://spades.bioinf.spbau.ru/release3.1.1/SPAdes-3.1.1.tar.gz"
  sha1 "fe316a7620599ae4e5b1cba92316f79cac107fa2"

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
