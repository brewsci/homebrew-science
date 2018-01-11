class Uniqtag < Formula
  homepage "https://github.com/sjackman/uniqtag"
  # doi "10.1101/007583"
  # tag "bioinformatics"

  head "https://github.com/sjackman/uniqtag.git"
  url "https://github.com/sjackman/uniqtag/archive/1.0.tar.gz"
  sha256 "8ff0dd850c15ff3468707ae38a171deb6518866a699964a1aeeec9c90ded7313"
  revision 1

  depends_on "ruby"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/uniqtag --version"
  end
end
