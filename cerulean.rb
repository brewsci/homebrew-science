class Cerulean < Formula
  homepage "https://sourceforge.net/projects/ceruleanassembler/"
  #doi "arXiv:1307.7933"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/ceruleanassembler/Cerulean_v_0_1.tar.gz"
  sha1 "535e3486da3cf1de5bbaee794c3c14c53b1ee4e4"

  depends_on "abyss" => :recommended
  depends_on "numpy" => :python

  def install
    doc.install "README"
    libexec.install Dir["src/*"]
    prefix.install "data"
  end

  test do
    system "python", "#{libexec}/Cerulean.py", "-h"
  end
end
