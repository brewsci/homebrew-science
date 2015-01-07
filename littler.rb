class Littler < Formula
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.1.tar.gz"
  sha1 "c9790df09bb07278420ef692b78df97757e9841c"
  head "https://github.com/eddelbuettel/littler.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "04e75e219fab465911d71abf7354024d04df93c5" => :yosemite
    sha1 "6992af49d574688a91a39f3bd2e8652e05b011b0" => :mavericks
    sha1 "0bbe3da33cddc9d966d7d0e441a4bc722651f822" => :mountain_lion
  end

  depends_on "r"

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
           "--prefix=#{prefix}"

    system "make"

    bin.install "r" => "littler"
    man1.install "r.1" => "littler.1"
    doc.install "README"
  end

  def caveats; <<-EOS.undent
    This formula installs `r` as `littler` to avoid conflicting
    with the Zsh builtin and case-insensitive filesystems.
    EOS
  end

  test do
    system "littler", "-e", "'print(pi)'"
  end
end
