class Wiggletools < Formula
  desc "Compute genome-wide statistics with composable iterators"
  homepage "https://github.com/Ensembl/WiggleTools"
  url "https://github.com/Ensembl/WiggleTools/archive/v1.2.1.tar.gz"
  sha256 "906d32e281fe234b3eacbe569c21e68d61aca3d0ef2eec501e4efd61799be4ee"
  head "https://github.com/Ensembl/WiggleTools.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btt737"

  bottle do
    cellar :any
    sha256 "20cdd6f7f97f118cefca6ead3cb09b3bdd27c67fe9ac505f650375bb2920d2bd" => :sierra
    sha256 "b10bcfe2fb5c97701529566f71bfe1ca9ad221643a5f0a0a2e8a0f5e7bc7ea0f" => :el_capitan
    sha256 "685b71b49b93f556c604b617525188c5cc658e4543e1df622be84f899d55c731" => :yosemite
    sha256 "af652e86fa4134a66a7f11c42bf9cb74eb13ac9fd96ab42d39c937d046914a87" => :x86_64_linux
  end

  depends_on "htslib"
  depends_on "gsl"

  resource "libbigwig" do
    url "https://github.com/dpryan79/libBigWig/archive/0.3.0.tar.gz"
    sha256 "221002fe249e8099009f0790f44bfe991e85cb23763cf5fc494e745c0160edc2"
  end

  def install
    resource("libbigwig").stage do
      system "make", "install", "prefix=#{prefix}"
      include.install "bigWig.h"
      lib.install "libBigWig.a", "libBigWig.so"
    end

    cp Dir.glob(include/"*.h"), "src"
    mkdir_p "lib"
    cp lib/"libBigWig.a", "lib"
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
