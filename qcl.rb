require 'formula'

class Qcl < Formula
  homepage 'http://tph.tuwien.ac.at/~oemer/qcl.html'
  url 'http://tph.tuwien.ac.at/~oemer/tgz/qcl-0.6.4.tgz'
  sha1 '4e2aed232e9bf68aee515f2a4de1c65ca6181722'

  depends_on 'flex'
  depends_on 'readline'

  fails_with :clang do
    cause 'Clang does not support variable-length arrays for non-POD types.'
  end

  def install
    system "make", "CXX=#{ENV.cxx}", "QCLDIR=#{prefix}/qcllib", "PLOPT=", "PLLIB="
    bin.install 'qcl'
    prefix.install 'lib' => 'qcllib'
  end
end
