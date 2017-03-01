class Xylib < Formula
  desc "Library for reading x-y data files"
  homepage "https://xylib.sourceforge.io/"
  url "https://github.com/wojdyr/xylib/releases/download/v1.5/xylib-1.5.tar.bz2"
  sha256 "cdda7aa84e548e90ad1b0afd41fbee5d90232ab3da0968661a7f37f801ea53e4"

  bottle do
    cellar :any
    sha256 "fe85102a18963b881845cabdc317107b90b5e9388850f088e79a969817c7aa11" => :sierra
    sha256 "edb9f67513a63c1f8f875992c6108a8018736822276a17d84ce3161d93058a38" => :el_capitan
    sha256 "c8d27a949f49981d28118da28973aa35bc05cdf20e4e4541706d9da6cb476e34" => :yosemite
    sha256 "edc37131aea31e51209b2c3b135220d6149064d11d14b8fdcbe4c2bb30554d13" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "wxmac"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"xyconv", "--version"
    (testpath/"with_sigma.txt").write "20.0 490.5"
    system "#{bin}/xyconv", "-g", "#{testpath}/with_sigma.txt"
  end
end
