class Pathvisio < Formula
  desc "Extendable Pathway Analysis Toolbox"
  homepage "http://www.pathvisio.org/"
  # tag "bioinformatics"
  # doi "10.1371/journal.pcbi.1004085"
  url "http://www.pathvisio.org/data/releases/current/pathvisio_bin-3.2.1-r4025.zip"
  version "3.2.1"
  sha256 "e0891d309ce4cd73ca5e22da2a041a921fed86eaa16bdb9318b52a363daee1d2"

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
