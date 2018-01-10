class Wiggletools < Formula
  desc "Compute genome-wide statistics with composable iterators"
  homepage "https://github.com/Ensembl/WiggleTools"
  url "https://github.com/Ensembl/WiggleTools/archive/v1.2.2.tar.gz"
  sha256 "e9e75b09bcc8aeb012c49937c543e2b05379d3983ba8f6798ca8d6a4171702d9"
  revision 1
  head "https://github.com/Ensembl/WiggleTools.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btt737"

  bottle do
    cellar :any
    sha256 "461d183d596237fc2e68094eeed0adfe48d75e8c7c08f1e11e5376c0ac556c22" => :sierra
    sha256 "8020b504935d5eb7145cc47608d6331b6d95411176c8a2b22ff2a011fe1cfd55" => :el_capitan
    sha256 "becc1a3137457844798f374372d24e8c95b50d052f1a46d925094b9a79a9c250" => :yosemite
    sha256 "b0d40d3b27977a053a2967446c2247d5d18bd939371ba919d8434781b6c0cc3b" => :x86_64_linux
  end

  depends_on "curl" unless OS.mac?
  depends_on "gsl"
  depends_on "htslib"
  depends_on "libbigwig"

  def install
    system "make"
    pkgshare.install "test"
    lib.install "lib/libwiggletools.a"
    bin.install "bin/wiggletools"
  end

  test do
    cp_r pkgshare/"test", testpath
    cp_r prefix/"bin", testpath
    cd "test" do
      system "python2.7", "test.py"
    end
  end
end
