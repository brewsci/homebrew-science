class Pathvisio < Formula
  desc "Extendable Pathway Analysis Toolbox"
  homepage "https://www.pathvisio.org/"
  url "https://www.pathvisio.org/data/releases/current/pathvisio_bin-3.2.4.zip"
  sha256 "b090e801dc427f574b26973d8f5e4ad9ce6972024b0d358cec43b94e157a8071"
  # doi "10.1371/journal.pcbi.1004085"
  # tag "bioinformatics"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install "LICENSE-2.0.txt", "NOTICE.txt", "pathvisio.jar", "pathvisio.sh"
    bin.write_jar_script libexec/"pathvisio.jar", "pathvisio"
    doc.install "readme.txt"
  end

  test do
    system "#{bin}/pathvisio", "-v"
  end
end
