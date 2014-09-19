require 'formula'

class Prodigal < Formula
  homepage 'http://prodigal.ornl.gov/'
  #doi '10.1186/1471-2105-11-119'
  #tag "bioinformatics"
  url "https://github.com/hyattpd/Prodigal/archive/v2.6.1.tar.gz"
  sha1 "aebcfbfb33010cbbba480c1db8b2ba5ebf5c7bd7"

  head 'https://github.com/hyattpd/Prodigal.git'

  def install
    system "make"
    mv "prodigal2", "prodigal" if build.head?
    bin.install 'prodigal'
  end

  test do
    system "#{bin}/prodigal -v"
  end
end
