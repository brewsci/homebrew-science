class Cdsclient < Formula
  desc "Tools for querying CDS databases"
  homepage "http://cdsarc.u-strasbg.fr/doc/cdsclient.html"
  url "http://cdsarc.u-strasbg.fr/ftp/pub/sw/cdsclient-3.80.tar.gz"
  sha256 "ed399b80e158c75730b61862c3ec467f061598f28e9649cb2c109562df489360"

  bottle do
    cellar :any
    sha256 "f721d5d4ff9c37c90db6e70fcb7c6d4fd69d526162d7a9dbaf9f0dff05bb3476" => :yosemite
    sha256 "3cf5e5544824dddfa2e5aa2eb25ab71ba7762c1f5f905411bbfadbe680fc0d3e" => :mavericks
    sha256 "d7f9c281d6053801733d7e127cfefc2c65c2885590a50049a341fa66574dbe39" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    man.mkpath
    system "make", "install", "MANDIR=#{man}"
  end

  test do
    (testpath/"data").write <<-EOS.undent
      12 34 12.5 -34 23 12
      13 24 57.1 +61 12 34
    EOS
    assert_match "#...upload ==>", pipe_output("#{bin}/findgsc - -r 5", testpath/"data", 0)
  end
end
