require "formula"

class Uniqtag < Formula
  homepage "https://github.com/sjackman/uniqtag"
  #doi "10.1101/007583"

  head "https://github.com/sjackman/uniqtag.git"
  url "https://github.com/sjackman/uniqtag/archive/1.0.tar.gz"
  sha1 "f507a3f61bc6abb6c992bae55b827b42d45be3bd"

  def install
    system "make", "install", "prefix=#{prefix}"
    doc.install "README.md"
  end

  test do
    system "#{bin}/uniqtag --version"
  end
end
