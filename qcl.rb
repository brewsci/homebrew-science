class Qcl < Formula
  homepage "http://tph.tuwien.ac.at/~oemer/qcl.html"
  url "http://tph.tuwien.ac.at/~oemer/tgz/qcl-0.6.4.tgz"
  sha256 "ff4d4899c5995bd75601e8125312ce20059f065326c29467b7f5dfa3a87d45f4"
  revision 1

  depends_on "flex"
  depends_on "readline"

  fails_with :clang do
    cause "Clang does not support variable-length arrays for non-POD types."
  end

  def install
    system "make", "CXX=#{ENV.cxx}", "QCLDIR=#{prefix}/qcllib", "PLOPT=", "PLLIB="
    bin.install "qcl"
    prefix.install "lib" => "qcllib"
  end
end
