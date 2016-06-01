class Scrm < Formula
  desc "Coalescent simulator for biological sequences."
  homepage "https://scrm.github.io/"
  url "https://github.com/scrm/scrm/releases/download/v1.7.2/scrm-src.tar.gz"
  version "1.7.2"
  sha256 "9897536696429959163aaee7dbb05ae17964a04a3f8b4dbb1f3af27c842516c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "efa9671e2aa0d2bca94b6505d5a1a3a0a7ef060baf74cd993a7f2be3398ec6c1" => :el_capitan
    sha256 "e310107e1c849fe48f62aee22587e933a466b8966fcb12e244066640c0bfa9b2" => :yosemite
    sha256 "6c10eb18ffd42087d567d06f15f94edf1082da57ee903435e5532b618cb92f41" => :mavericks
  end

  option "without-test", "Disable build-time testing (not recommended)"

  depends_on "cppunit" if build.with? "test"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    assert_equal shell_output("#{bin}/scrm 10 1 -seed 1 2 3 -T"), <<-EOS.undent
      scrm 10 1 -seed 1 2 3 -T
      4199328558

      //
      ((6:0.0435293,(1:0.00419747,2:0.00419747):0.0393318):0.774018,((10:0.0734249,7:0.0734249):0.60889,(9:0.62083,(8:0.173813,(4:0.149547,(5:0.00360041,3:0.00360041):0.145947):0.0242657):0.447016):0.0614849):0.135233);
    EOS
  end
end
