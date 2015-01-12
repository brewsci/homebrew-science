class Minia < Formula
  homepage "http://minia.genouest.org/"
  #doi "10.1186/1748-7188-8-22"
  #tag "bioinformatics"

  url "http://minia.genouest.org/files/minia-1.6906.tar.gz"
  sha1 "f54003afbd4e2f3e8b52db08e1d7fca644e751fa"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "34f0ed9d3fda6e77e8599243c76b170173d278d5" => :yosemite
    sha1 "f7b5951bed434296fe0e0b5c81860968c5ef25ce" => :mavericks
    sha1 "0c481c6b6d53590a695c87542ad1428584d317f8" => :mountain_lion
  end

  def install
    system "make"
    bin.install "minia"
    doc.install "README", "manual/manual.pdf"
  end

  test do
    system "#{bin}/minia 2>&1 |grep -q minia"
  end
end
