class Qcl < Formula
  homepage "http://tph.tuwien.ac.at/~oemer/qcl.html"
  url "http://tph.tuwien.ac.at/~oemer/tgz/qcl-0.6.4.tgz"
  sha256 "ff4d4899c5995bd75601e8125312ce20059f065326c29467b7f5dfa3a87d45f4"
  bottle do
    sha256 "22b60af8ca4efd78ec9ffc999da2030da4f6f78f9fd70b9977c965656bf325d9" => :sierra
    sha256 "eb822dda6f8c6703df6179896840dc3ccf03724a166d16622fd0d9ce6f51a382" => :el_capitan
    sha256 "366c9ca1b69b4bafd1d2b9d137815fd5475ded49c03837c00fd7696fb424b5ca" => :yosemite
  end

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
