class Musket < Formula
  homepage "http://musket.sourceforge.net/"
  #doi "10.1093/bioinformatics/bts690"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/musket/musket-1.1.tar.bz"
  sha1 "48b0c6eba3c00be0dd4eab9aef7ed199e3e97857"

  def install
    system "make"
    bin.install "musket"
    doc.install "LICENSE", "README"
  end

  test do
    system "#{bin}/musket 2>&1 |grep musket"
  end
end
