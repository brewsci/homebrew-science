class Cdsclient < Formula
  desc "Tools for querying CDS databases"
  homepage "http://cdsarc.u-strasbg.fr/doc/cdsclient.html"
  url "http://cdsarc.u-strasbg.fr/ftp/pub/sw/cdsclient-3.83.tar.gz"
  sha256 "0c348b5bfb5b5853de77604d082bee1a592718f83e021fa151582a1ddfa2cfaf"

  bottle do
    cellar :any_skip_relocation
    sha256 "42c127f775025c68692ffff3e3b77b56902c8213ece14fd11b490d6ad51e37ee" => :el_capitan
    sha256 "e3f68d0387bf312ec05e2a7bda8a228a6a1392777cb97550cf2196b2b452b2f8" => :yosemite
    sha256 "6a2eb43b162d4d787bf9aa1f0d2de8fd3781f0757203d4664dee9d5cc7b37d56" => :mavericks
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
