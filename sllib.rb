class Sllib < Formula
  homepage "https://www.ir.isas.jaxa.jp/~cyamauch/sli/index.html"
  url "https://www.ir.isas.jaxa.jp/~cyamauch/sli/sllib-1.4.5.tar.gz"
  sha256 "149e4677b7636b6feaebe9d2b6f72597829209cc4eda1386bdfa1d5dfb9cc6bc"

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
