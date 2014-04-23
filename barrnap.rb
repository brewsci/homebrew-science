require "formula"

class Barrnap < Formula
  homepage "http://www.vicbioinformatics.com/software.barrnap.shtml"
  url "http://www.vicbioinformatics.com/barrnap-0.3.tar.gz"
  sha1 "bcc58676520048fc28072bf29f12cf50fb77240f"
  head "https://github.com/Victorian-Bioinformatics-Consortium/barrnap.git"

  depends_on "hmmer"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../barrnap"
  end

  test do
    system "#{bin}/barrnap --version"
  end
end
