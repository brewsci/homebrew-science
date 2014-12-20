class ClustalW < Formula
  homepage "http://www.clustal.org/clustal2/"
  #tag "bioinformatics"
  #doi "10.1093/nar/22.22.4673"
  url "http://www.clustal.org/download/2.1/clustalw-2.1.tar.gz"
  sha1 "f29784f68585544baa77cbeca6392e533d4cf433"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "60bf60642a075b54773032eca33594f01cd92a4c" => :yosemite
    sha1 "38c7402db59638e80c44384c94106266bdb427e5" => :mavericks
    sha1 "42f9faaf5f18d12dc7ac0aa269c36b580dbdfd24" => :mountain_lion
  end

  fails_with :clang do
    build 600
    cause "error: implicit instantiation of undefined template"
  end

  fails_with :gcc => "4.2"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/clustalw2 --version 2>&1 |grep CLUSTAL"
  end
end
