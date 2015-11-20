class Minia < Formula
  homepage "http://minia.genouest.org/"
  #doi "10.1186/1748-7188-8-22"
  #tag "bioinformatics"

  url "http://minia.genouest.org/files/minia-1.6906.tar.gz"
  sha1 "f54003afbd4e2f3e8b52db08e1d7fca644e751fa"

  bottle do
    cellar :any
    sha256 "d7ad9d373defc2a515d26b1f583e936b035e724b41f1590171cdcd9e462b2a37" => :yosemite
    sha256 "b774c469fa25cd621b0bf12109c3fee1c93473e4bd3e2ef4686b4fa73bb5e910" => :mavericks
    sha256 "5858e2410ed92dd870e30e2d1ac8f373812ca472a7e3bd5d84ff5a05fd7249aa" => :mountain_lion
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
