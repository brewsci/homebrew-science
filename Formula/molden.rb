class Molden < Formula
  desc "Pre- and post-processing of molecular and electronic structure"
  homepage "http://www.cmbi.ru.nl/molden/"
  url "ftp://ftp.cmbi.ru.nl/pub/molgraph/molden/molden5.7.tar.gz"
  sha256 "5e7b3a8bf9251626d362b1d1dd8e4362054e6bce505c43e10254265857bb6e7d"
  revision 1
  # tag "chemistry"
  # doi "10.1023/A:1008193805436"

  bottle do
    cellar :any
    sha256 "7090e6426c40c0a4adb6ec5f5ded9872b2df113d5405b81c835894f564700d2c" => :sierra
    sha256 "c90a972af21039dc32134854a1623379fd5f805a72db4a325246ad4f0baf70dd" => :el_capitan
    sha256 "ae95c0cad20b100600b9ba8271ed1d572e47a5896bede7c39315586e7ed8383b" => :yosemite
  end

  depends_on :x11
  depends_on :fortran

  def install
    system "make"
    bin.install "molden", "gmolden"
  end

  def caveats; <<-EOS.undent
    Two versions of Molden were installed:
      - gmolden is the full OpenGL version
      - molden is the Xwindows version
    EOS
  end

  test do
    # molden is an interactive program, there is not much we can test here
    assert_match "Molden#{version}", shell_output("#{bin}/gmolden -h")
  end
end
