class Edena < Formula
  homepage "http://www.genomic.ch/edena.php"
  url "http://www.genomic.ch/edena/EdenaV3.131028.tar.gz"
  sha256 "4037fce486c9725107b1690fbc67731713eef54e3fa53081865904c783533230"

  def install
    ENV.deparallelize
    system "make"
    bin.install "src/edena"
    doc.install "COPYING", "referenceManual.pdf"
  end

  def caveats
    <<-EOS.undent
      The documentation installed into
          #{HOMEBREW_PREFIX}/share/doc/#{name}
    EOS
  end

  test do
    system "edena"
  end
end
