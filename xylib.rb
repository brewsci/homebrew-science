class Xylib < Formula
  desc "Library for reading x-y data files"
  homepage "http://xylib.sourceforge.net"
  url "https://github.com/wojdyr/xylib/releases/download/v1.5/xylib-1.5.tar.bz2"
  sha256 "cdda7aa84e548e90ad1b0afd41fbee5d90232ab3da0968661a7f37f801ea53e4"

  bottle do
    cellar :any
    sha256 "f2a64677c28a222ce550acb82e3750f8b207d39e449f6e1e42bbf3c2043cf39c" => :el_capitan
    sha256 "f2bc5c95286d70a8e0c4b47adc52f18ed5d689b221124fcd48d989ad4817f2ce" => :yosemite
    sha256 "fb54f652065bffde6c8675025a18b06d54d71bb08e3acef4a6408e6799d9fa2a" => :mavericks
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
