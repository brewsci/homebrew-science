class Wiggletools < Formula
  desc "Compute genome-wide statistics with composable iterators"
  homepage "https://github.com/Ensembl/WiggleTools"
  url "https://github.com/Ensembl/WiggleTools/archive/v1.2.1.tar.gz"
  sha256 "906d32e281fe234b3eacbe569c21e68d61aca3d0ef2eec501e4efd61799be4ee"
  revision 1
  head "https://github.com/Ensembl/WiggleTools.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btt737"

  bottle do
    cellar :any
    sha256 "9f6500335040898f1f7db2466d209fb974d0cf947a30ff35e0af69a4cffa07d6" => :sierra
    sha256 "3e39c9ffafb0e06f67d9c1a12c8e0c9ec4927c6dbb84e6faf0e221a0a53ab982" => :el_capitan
    sha256 "19c386d78ae9b362a242abcc791f438660e9cf73e9a815cea819163f0bba8178" => :yosemite
  end

  depends_on "htslib"
  depends_on "gsl"
  depends_on "curl" unless OS.mac?

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
