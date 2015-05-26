class ClustalOmega < Formula
  homepage "http://www.clustal.org/omega/"
  #tag "bioinformatics"
  #doi "10.1038/msb.2011.75"
  url "http://www.clustal.org/omega/clustal-omega-1.2.1.tar.gz"
  sha1 "50f67eb3244c25c9380e7afef0e157161535121b"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "542ab8b7114dcc9ecbe18ff30241636f3ce6119f" => :yosemite
    sha1 "ef3fb88b983cf5513f78db6973bbb9d47f2b4d61" => :mavericks
    sha1 "3f39c602cfa65c5e9c886417eca892af52fc4246" => :mountain_lion
  end

  depends_on "argtable"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/clustalo", "--version"
  end
end
