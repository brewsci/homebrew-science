class Sollya < Formula
  desc "Environment for the development of numerical codes"
  homepage "http://sollya.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/file/36271/sollya-6.0.tar.bz2"
  sha256 "05321581ba47f5e0804b712157dfc5343a268ca6c1983dce48fdd1e91d5b0a1f"
  head "https://scm.gforge.inria.fr/anonscm/git/sollya/sollya.git"
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
