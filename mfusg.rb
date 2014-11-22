require "formula"

class Mfusg < Formula
  homepage "http://water.usgs.gov/ogw/mfusg"
  url "http://water.usgs.gov/ogw/mfusg/mfusg.1_2_00.zip"
  sha1 "ab25e4e816ad3c9b83720b7b367ddd4e287caf0f"
  revision 1

  depends_on :python
  depends_on :fortran

  def install
    prefix.install "mfusg.txt", "readme.txt", "release.txt", "problems.txt"
    share.install "test"
    doc.install Dir["doc/*"]
    Dir.chdir "pymake"
    system "python", "makebin.py"
    bin.install "mfusg"
  end

  test do
    system "#{bin}/mfusg", "#{share}/test/03_conduit_confined/ex3.nam"
  end
end
