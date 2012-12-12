require 'formula'

class Hyphy < Formula
  homepage 'http://www.hyphy.org/'
  url 'https://github.com/veg/hyphy/archive/2.1.2.tar.gz'
  sha1 '3e8708256c92ee84c0ade5a69b20070fa20e103f'
  head 'https://github.com/veg/hyphy.git'

  depends_on 'cmake' => :build

  def patches
    # Single-threaded builds. This commit is from upstream and will
    # be included in the next release.
    'https://github.com/veg/hyphy/commit/c90bf9b93218a38e4c9f12150ffe36eb.diff'
  end

  def install
    system "cmake", "-DINSTALL_PREFIX=#{prefix}", ".", *std_cmake_args
    system "make SP"
    system "make install"
    (share/'hyphy').install('help')
  end

  def caveats; <<-EOS.undent
    This formula builds a single-threaded version of HyPhy, as multithreaded
    builds occasionally hang on certain analyses.

    The help has been installed to #{HOMEBREW_PREFIX}/share/hyphy.
    EOS
  end
end
