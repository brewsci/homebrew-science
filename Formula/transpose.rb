class Transpose < Formula
  desc "Fast efficient tranpose of plain text matrix data"
  homepage "https://transpose.sourceforge.io/"

  url "https://downloads.sourceforge.net/project/transpose/transpose/transpose-2.0/2.0/transpose-2.0.zip"
  sha256 "cc287954901364e6a4e4e2fd41eef74550a1b5cb2649d09dd2f3f2ac99fc009e"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, sierra:        "ac6fda93b14a381dacff88622faa85270952a60bdd13f12661791708c7075080"
    sha256 cellar: :any, el_capitan:    "5881277a918b9deeb74df9eaf1b8136b3b09a7d0c93ae96c077a2a6826cc64b5"
    sha256 cellar: :any, yosemite:      "cbc7684f60be84826b10ede4017a99fa285f74e336acb17ef58a6503cf35a89d"
    sha256 cellar: :any, mavericks:     "1f96e5d4c395b4014b6b03f1504ca34f8caedf90358b3414e59989a3c0f2a74e"
    sha256 cellar: :any, mountain_lion: "670ca6ed3cbef04b3f4e4763527568a7206c5d2418d7bbe529e80ec14fc39e69"
  end

  def install
    system ENV.cc, "-O3", "-o", "transpose", "src/transpose.c"
    bin.install "transpose"
    doc.install "README"
  end

  test do
    (testpath/"test.tab").write <<~EOS
      1	2
      3	4
    EOS
    assert_match "1\t3\n2\t4\n", shell_output("#{bin}/transpose -t #{testpath}/test.tab")
  end
end
