require "formula"

class Fwdpp < Formula
  homepage "http://www.molpopgen.org/software/fwdpp"
  url "https://github.com/molpopgen/fwdpp/archive/0.2.0.tar.gz"
  sha1 "e3371221c0bd352ccfb231d1b060ed7c26707bcc"
  head "https://github.com/molpopgen/fwdpp.git"

  depends_on 'gsl'
  depends_on 'boost' => :build
  depends_on 'libsequence'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "-C", "examples"
    share.install Dir['examples']
  end

  test do
    # run one of the example programs (https://github.com/molpopgen/fwdpp#diploid)
    system "#{share}/examples/diploid 1000 10 10 1000 50 1 272"
  end
end
