class Parsnp < Formula
  homepage "https://github.com/marbl/parsnp"
  # tag "bioinformatics"
  # doi "10.1186/s13059-014-0524-x"

  head "https://github.com/marbl/parsnp.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "eb6802a03f95fcd3f9d918ce03aea2f2da3cafc8" => :yosemite
    sha1 "63d40206dcf353a9624e3f10913a17b2f1a6915d" => :mavericks
    sha1 "8090d479662d6aae0d5e8f395f7e1aaba4fc976d" => :mountain_lion
  end

  if OS.mac?
    url "https://github.com/marbl/parsnp/releases/download/v1.1/parsnp-OSX64-v1.1.tar.gz"
    sha1 "230387082702a57ad41989507a8c1f7c63d4dfd0"
  elsif OS.linux?
    url "https://github.com/marbl/parsnp/releases/download/v1.1/parsnp-Linux64-v1.1.tar.gz"
    sha1 "443d2db8b498081b1c608ce8641d25dfcc39ad48"
  end

  def install
    bin.install "parsnp"
  end

  test do
    system "#{bin}/parsnp", "-h"
  end
end
