class Pathvisio < Formula
  desc "Extendable Pathway Analysis Toolbox"
  homepage "http://www.pathvisio.org/"
  url "http://www.pathvisio.org/data/releases/current/pathvisio_bin-3.2.2-r4047.zip"
  version "3.2.2"
  sha256 "040b83694baa87e99cbe091cbc7d2e54c91fcfb4f80a3e57f20d32a7c64080e1"
  # doi "10.1371/journal.pcbi.1004085"
  # tag "bioinformatics"

  bottle :unneeded

  depends_on :java => "1.7"

  def install
    libexec.install "LICENSE-2.0.txt", "NOTICE.txt", "pathvisio.jar", "pathvisio.sh"
    bin.write_jar_script libexec/"pathvisio.jar", "pathvisio"
    doc.install "readme.txt"
  end

  test do
    system "#{bin}/pathvisio", "-v"
  end
end
