require "formula"

class Fsa < Formula
  homepage "http://fsa.sourceforge.net/"
  #doi "10.1371/journal.pcbi.1000392"
  #tag "bioinformatics"
  url "https://downloads.sourceforge.net/project/fsa/fsa-1.15.9.tar.gz"
  sha1 "457aee5baca17357e52041eac7e3ecbc226bea75"

  depends_on "mummer" => :recommended

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fsa --version"
  end
end
