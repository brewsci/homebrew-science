class Mrfast < Formula
  homepage "http://mrfast.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mrfast/mrfast/mrfast-2.6.1.0.tar.gz"
  sha256 "dc040b1517945f900cbc9d69ed4528573f681bf723ccd1431b47cb5c22b2cdef"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=-c #{ENV.cflags}"
    bin.install "mrfast"
  end

  test do
    (testpath/"test.fasta").write ">0\nMEEPQSDPSV\n"
    system bin/"mrfast", "--index", testpath/"test.fasta"
  end
end
