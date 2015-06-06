class Transpose < Formula
  desc "Fast efficient tranpose of plain text matrix data"
  homepage "http://transpose.sourceforge.net/"

  url "https://downloads.sourceforge.net/project/transpose/transpose/transpose-2.0/2.0/transpose-2.0.zip"
  sha256 "cc287954901364e6a4e4e2fd41eef74550a1b5cb2649d09dd2f3f2ac99fc009e"

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
