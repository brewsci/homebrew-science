class Fastml < Formula
  homepage "http://fastml.tau.ac.il/source.php"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/18.8.1116"

  url "http://fastml.tau.ac.il/source/FastML.v3.1.tgz"
  sha256 "16c8631a4186f434f81f5b7e8c1147660e79b025b3c93a6db9889c30477bd5f4"

  bottle do
    cellar :any
    sha256 "522293e9f76d618eef20ed52e8b161fe00c1c59d7152bd643ad07811e0e99750" => :yosemite
    sha256 "9b6fef363a5cf10cea598b57a9d77ae80c773c5b0f6e39d4187895616121557b" => :mavericks
  end

  depends_on :macos => :mavericks # won't build on [Mountain] Lion

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
