class Fastml < Formula
  homepage "http://fastml.tau.ac.il/source.php"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/18.8.1116"

  url "http://fastml.tau.ac.il/source/FastML.v3.1.tgz"
  sha256 "16c8631a4186f434f81f5b7e8c1147660e79b025b3c93a6db9889c30477bd5f4"

  depends_on :macos => :mavericks   # won't build on [Mountain] Lion

  def install
    mkdir "bin"
    system "make", "install"
    bin.install Dir["bin/*"]
    doc.install "README"
  end

  test do
    assert_match "Jukes", shell_output("fastml 2>&1")
    assert_match "Phyletic", shell_output("gainLoss 2>&1")
    assert_match "logValue", shell_output("indelCoder 2>&1")
  end
end
