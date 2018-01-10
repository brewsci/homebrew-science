class Mrfast < Formula
  homepage "https://mrfast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mrfast/mrfast/mrfast-2.6.1.0.tar.gz"
  sha256 "dc040b1517945f900cbc9d69ed4528573f681bf723ccd1431b47cb5c22b2cdef"

  bottle do
    cellar :any
    sha256 "2a8a3f7c2f7f336942ddfa2efae0a2a7fb2daa353258390af202887c87de944f" => :yosemite
    sha256 "4443cb3e4ff648f90729ee779b2ea735add1814a1b44d760afb41ea91c78297d" => :mavericks
    sha256 "196c04165756895e9c9e4e317ebd9b44c65b9b68137d11f419bd74c548619522" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=-c #{ENV.cflags}"
    bin.install "mrfast"
  end

  test do
    (testpath/"test.fasta").write ">0\nMEEPQSDPSV\n"
    system bin/"mrfast", "--index", testpath/"test.fasta"
  end
end
