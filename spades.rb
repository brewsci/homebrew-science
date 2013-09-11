require 'formula'

class Spades < Formula
  homepage 'http://bioinf.spbau.ru/spades/'
  url 'http://spades.bioinf.spbau.ru/release2.5.1/SPAdes-2.5.1.tar.gz'
  sha1 '10ea07038cf47ad0a5a9d55c2a2664c0be2fbf52'

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
