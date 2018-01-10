class Sollya < Formula
  desc "Environment for the development of numerical codes"
  homepage "http://sollya.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/file/36271/sollya-6.0.tar.bz2"
  sha256 "05321581ba47f5e0804b712157dfc5343a268ca6c1983dce48fdd1e91d5b0a1f"
  revision 2
  head "https://scm.gforge.inria.fr/anonscm/git/sollya/sollya.git"

  bottle do
    cellar :any
    sha256 "0bdf63143ce17ed5dfb2fb806fd035635d46f1f5b2e189afbaef419c3da878ee" => :sierra
    sha256 "430e46f8eb66ba72b757d44bf78bda39950536fff589994e68c7280798def4e9" => :el_capitan
    sha256 "344b8d77fd5cabfee3698e18cd02b0106a03996ca9f185c3258b3f9dd664e0c8" => :x86_64_linux
  end

  # doi "10.1007/978-3-642-15582-6_5"

  option "with-test", "Run full test suite (time consuming)"

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "mpfi"
  depends_on "fplll"
  depends_on "libxml2" unless OS.mac?

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
