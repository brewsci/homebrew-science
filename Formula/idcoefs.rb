class Idcoefs < Formula
  homepage "https://code.google.com/p/idcoefs/"
  url "https://idcoefs.googlecode.com/files/Idcoefs2_1_1.tar.gz"
  sha256 "412fd82d5d9cc1ec75e4f16c495e7e05edeefdb90ece1f27e157d2c799e7d1c0"

  def install
    system "make"
    bin.install("idcoefs")
    doc.install("Example")
  end

  test do
    system "#{bin}/idcoefs",
             "-p", "#{doc}/Example/ex.pedigree",
             "-s", "#{doc}/Example/ex.study",
             "-o", "foo.out"
    system "diff", "foo.out", "#{doc}/Example/ex.output"
  end
end
