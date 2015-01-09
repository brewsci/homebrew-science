class Minia < Formula
  homepage "http://minia.genouest.org/"
  #doi "10.1186/1748-7188-8-22"
  #tag "bioinformatics"

  url "http://minia.genouest.org/files/minia-1.6906.tar.gz"
  sha1 "f54003afbd4e2f3e8b52db08e1d7fca644e751fa"

  def install
    system "make"
    bin.install "minia"
    doc.install "README", "manual/manual.pdf"
  end

  test do
    system "#{bin}/minia 2>&1 |grep -q minia"
  end
end
