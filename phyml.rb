class Phyml < Formula
  desc "Fast maximum likelihood-based phylogenetic inference"
  homepage "http://www.atgc-montpellier.fr/phyml/"
  url "https://github.com/stephaneguindon/phyml/archive/v3.2.0.tar.gz"
  sha256 "9fec8fc26e69cad8d58bf2c9433b531754e4f026dc3464d07958b6c824783fde"
  # tag "bioinformatics"
  # doi "10.1093/sysbio/syq010"

  bottle do
    cellar :any_skip_relocation
    sha256 "54afc7cc2ff1bfbe3ee89b60431132e4ab57d0ff9091677846ae3c306603d55d" => :el_capitan
    sha256 "10f0ed39855d390490c069e16da43ec98b106acde013201fb9e757bb25f3ec8d" => :yosemite
    sha256 "dac19c8053a821f6a28057cd67863733b48c3372309f1d8bacfa904e2da5701e" => :mavericks
    sha256 "37737392a5d053b12831167dc4eed1f7dc1fd722ed4e64d6c5c2d03eb7635de8" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    chmod 0755, 'autogen.sh'
    system "./autogen.sh"

    # separate steps required
    system "./configure", "--prefix=#{prefix}"
    system "make"

    bin.install "src/phyml"
    doc.install "doc/phyml-manual.pdf"
    pkgshare.install Dir["examples/*"]
  end

  def caveats; <<-EOS.undent
    Examples have been installed here:
      #{opt_pkgshare}

    See options for phyml by running:
      phmyl --help

    PhyML must be run with the "-i" option to specify an input or it will
    segfault. Example:
      phyml -i #{opt_pkgshare}/nucleic
    EOS
  end
end
