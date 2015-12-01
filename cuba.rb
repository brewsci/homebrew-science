class Cuba < Formula
  homepage "http://www.feynarts.de/cuba"
  url "http://www.feynarts.de/cuba/Cuba-4.1.tar.gz"
  sha256 "0928fb2911b77a72a9d01c75f5ed9962f46f5f7e2d913baf7b302395ac851f5f"

  bottle do
    cellar :any
    sha256 "bb7790282cc4763dab620bd6fef3453317a54f91eae920a57767d9b508329ca2" => :yosemite
    sha256 "9d64b534a14d2c3ea2e5293fa31c1dce3f26b4583ccd1eb12e55ce1dbe74891d" => :mavericks
    sha256 "ee8416e347157716805e856441202ff1ee6fc3af8710512116310b30471337f2" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--datadir=#{share}/cuba/doc"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"

    (share / "cuba").install "demo"
  end

  test do
    system ENV.cc, "-o", "demo-c", "#{lib}/libcuba.a", "#{share}/cuba/demo/demo-c.c"
    system "./demo-c"
  end
end
