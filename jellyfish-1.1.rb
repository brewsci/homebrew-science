require 'formula'

class Jellyfish11 < Formula
  homepage 'http://www.cbcb.umd.edu/software/jellyfish/'
  #doi "10.1093/bioinformatics/btr011"
  url 'http://www.cbcb.umd.edu/software/jellyfish/jellyfish-1.1.11.tar.gz'
  sha1 '8bd6a7b382e94d37adfddd916dec2b0e36f840fd'

  keg_only "It conflicts with jellyfish."

  fails_with :clang do
    build 503
    cause "error: variable length array of non-POD element type"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jellyfish --version"
  end
end
