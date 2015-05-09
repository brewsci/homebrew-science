class Pathvisio < Formula
  homepage "http://www.pathvisio.org/"
  # tag "bioinformatics"
  # doi "10.1186/1471-2105-9-399"
  url "http://pathvisio.org/data/releases/current/pathvisio_bin-3.2.0-r3999.tar.gz"
  sha256 "77464484215f954c75d506df5d92361568e36afa2caa7d12d123a460f32766d8"
  version "3.2.0"

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
