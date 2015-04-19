class Cdsclient < Formula
  desc "Tools for querying CDS databases"
  homepage "http://cdsarc.u-strasbg.fr/doc/cdsclient.html"
  url "http://cdsarc.u-strasbg.fr/ftp/pub/sw/cdsclient-3.80.tar.gz"
  sha256 "ed399b80e158c75730b61862c3ec467f061598f28e9649cb2c109562df489360"

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
