class Sllib < Formula
  homepage "https://www.ir.isas.jaxa.jp/~cyamauch/sli/index.html"
  url "https://www.ir.isas.jaxa.jp/~cyamauch/sli/sllib-1.4.5.tar.gz"
  sha256 "149e4677b7636b6feaebe9d2b6f72597829209cc4eda1386bdfa1d5dfb9cc6bc"

  bottle do
    cellar :any
    sha256 "e41419c2d18c872a48c2b5165c9d4a048471c3a9a81b8a6362d88f615ca472ec" => :high_sierra
    sha256 "65c7396911355831597843d36422ca1ca68cd40f5d56038e870a86b6bee3201d" => :sierra
    sha256 "83ec434d44643b8b87669fff66e250d31ac0c258923ac0c43fa85a8fe6e8856f" => :el_capitan
    sha256 "7d4b844441263fb5723f81867bc0909e60ff1e3644611c8311a4d57e1ba87ce2" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "bzip2"
    depends_on "ncurses"
    depends_on "readline"
    depends_on "zlib"
  end

  def install
    system "sh", "configure", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end
