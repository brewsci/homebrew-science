require 'formula'

class Joinx < Formula
  homepage 'http://gmt.genome.wustl.edu/joinx'
  url 'https://github.com/genome/joinx.git', :tag => 'v1.7.4'
  sha1 '30a6e30dc46a4c8a5ca01efb7517308d12a5ca7e'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    mkdir 'build' do
      system 'cmake', '..', *std_cmake_args
      system 'make', 'install'
    end
  end

  test do
    system 'joinx --version 2>&1 |grep -q joinx'
  end
end
