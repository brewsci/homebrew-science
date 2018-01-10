class Cuba < Formula
  homepage "http://www.feynarts.de/cuba"
  url "http://www.feynarts.de/cuba/Cuba-4.2.tar.gz"
  sha256 "6b75bb8146ae6fb7da8ebb72ab7502ecd73920efc3ff77a69a656db9530a5eef"

  bottle do
    cellar :any_skip_relocation
    sha256 "06bc2a5f602de65f466164c075dfba2045bf63c270cf17bd6604a3854a694f5f" => :high_sierra
    sha256 "ce92a393821cb06d4f05ea8b33ff530fd387cfb580d2c24a51cccdfccfe3bcc6" => :sierra
    sha256 "37157372c09da329f43cdcdf031ca56657d6038ac7a8a44c479ec7a69dfc64de" => :el_capitan
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
