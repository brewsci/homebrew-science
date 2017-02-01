class Cddlib < Formula
  desc "Double description method for general polyhedral cones"
  homepage "http://www.inf.ethz.ch/personal/fukudak/cdd_home/"
  url "ftp://ftp.math.ethz.ch/users/fukudak/cdd/cddlib-094h.tar.gz"
  sha256 "fe6d04d494683cd451be5f6fe785e147f24e8ce3ef7387f048e739ceb4565ab5"
  # doi "math"
  # doi "10.1007/3-540-61576-8_77"

  bottle do
    cellar :any
    sha256 "0017f86e0256835b7bdfc2e09f711ecf406a4024a192d13c4f71aaf88b8d7a05" => :yosemite
    sha256 "6e9826434d6d65332469e39cd4afb3069400786d16f0e9224a910070f260a76f" => :mavericks
    sha256 "2643cad2d5286a6a17d8b1252b2d607983f8e542c84daed5f7fdf2ed17404594" => :mountain_lion
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/*"]
    pkgshare.install Dir["examples*"]
  end

  test do
    system "#{bin}/testshoot"
  end
end
