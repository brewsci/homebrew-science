require 'formula'

class Prodigal < Formula
  homepage 'http://prodigal.ornl.gov/'
  url 'https://github.com/hyattpd/Prodigal/archive/v2.60.tar.gz'
  sha1 '3de4d1c64c6250cb38f37853c0edef885e03b5f5'

  head 'https://github.com/hyattpd/Prodigal.git'

  def install
    system "make"
    mv "prodigal2", "prodigal" if build.head?
    bin.install 'prodigal'
  end
end
