class Parsnp < Formula
  homepage "https://github.com/marbl/parsnp"
  # tag "bioinformatics"
  # doi "10.1186/s13059-014-0524-x"

  head "https://github.com/marbl/parsnp.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "af0037b92270e74ceb80b73786ef48eb59b84631" => :yosemite
    sha1 "7c06289d5ed3f3a82ca3249f3be52e99076afc7c" => :mavericks
    sha1 "7d6a77928bef48b20e3a7a83704949a161fe0391" => :mountain_lion
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
