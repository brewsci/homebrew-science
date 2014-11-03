require "formula"

class Littler < Formula
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.1.tar.gz"
  sha1 "c9790df09bb07278420ef692b78df97757e9841c"
  head "https://github.com/eddelbuettel/littler.git"

  depends_on "r"

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
           "--prefix=#{prefix}"

    system "make"
    # r conflicts with the zsh builtin and is not good for a
    # case-insensitive file system where it conflicts with R
    bin.install "r" => "littler"
    man1.install "r.1" => "littler.1"
    doc.install "README"
  end

  test do
    system %q[littler -e 'print(pi)']
  end
end
