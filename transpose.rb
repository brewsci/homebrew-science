class Transpose < Formula
  desc "Fast efficient tranpose of plain text matrix data"
  homepage "http://transpose.sourceforge.net/"

  url "https://downloads.sourceforge.net/project/transpose/transpose/transpose-2.0/2.0/transpose-2.0.zip"
  sha256 "cc287954901364e6a4e4e2fd41eef74550a1b5cb2649d09dd2f3f2ac99fc009e"

  bottle do
    cellar :any
    sha256 "cbc7684f60be84826b10ede4017a99fa285f74e336acb17ef58a6503cf35a89d" => :yosemite
    sha256 "1f96e5d4c395b4014b6b03f1504ca34f8caedf90358b3414e59989a3c0f2a74e" => :mavericks
    sha256 "670ca6ed3cbef04b3f4e4763527568a7206c5d2418d7bbe529e80ec14fc39e69" => :mountain_lion
  end

  def install
    system ENV.cc, "-O3", "-o", "transpose", "src/transpose.c"
    bin.install "transpose"
    doc.install "README"
  end

  test do
    (testpath/"test.tab").write <<-EOS.undent
       1	2
       3	4
    EOS
    assert_match "1\t3\n2\t4\n", shell_output("transpose -t #{testpath}/test.tab")
  end
end
