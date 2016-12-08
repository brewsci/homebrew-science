class Sollya < Formula
  desc "Environment for the development of numerical codes"
  homepage "http://sollya.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/file/36271/sollya-6.0.tar.bz2"
  sha256 "05321581ba47f5e0804b712157dfc5343a268ca6c1983dce48fdd1e91d5b0a1f"
  head "https://scm.gforge.inria.fr/anonscm/git/sollya/sollya.git"
  bottle do
    cellar :any
    sha256 "f91eef8bbf199d0d8303b84ad048892ccbf48f20ab3c5bdff345f863d2a56e34" => :sierra
    sha256 "3b7031eb8f5217cbeddee252819708ad50f81bd15c811726188c2aa91dee254d" => :el_capitan
    sha256 "62f084ab101dbed39a6b459b26762670cf78393b1bfbde381eb0efb1831d6ee8" => :yosemite
  end

  # doi "10.1007/978-3-642-15582-6_5"

  option "with-test", "Run full test suite (time consuming)"

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "mpfi"
  depends_on "fplll"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"sample.sollya").write <<-EOS.undent
    1+x==1+x;
    EOS
    assert_match "true", shell_output("#{bin}/sollya sample.sollya", 3)
  end
end
