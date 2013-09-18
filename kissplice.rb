require 'formula'

class Kissplice < Formula
  homepage 'http://kissplice.prabi.fr'
  url 'https://gforge.inria.fr/frs/download.php/32849/kissplice-1.8.3.tar.gz'
  sha1 'da33f59b66a62faa5b71aae9b46a595e45be3383'

  depends_on 'cmake' => :build

  def install
    system 'cmake', '.', *std_cmake_args
    system 'make', 'install'
  end

  test do
    system 'kissplice --version'
  end
end
