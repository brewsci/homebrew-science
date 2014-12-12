require "formula"

class Mhap < Formula
  homepage "https://github.com/marbl/MHAP"
  head "https://github.com/marbl/MHAP.git"
  #doi "10.1101/008003" => "bioRxiv"
  #tag "bioinformatics"

  url "https://github.com/marbl/MHAP/releases/download/v0.1/mhap-0.1.tar.gz"
  sha1 "c98096803c12d9d5e5281f0bf7809d909bccf185"

  def install
    prefix.install "mhap-0.1.jar", Dir["lib/*"]
    bin.write_jar_script prefix/"mhap-0.1.jar", "mhap"
  end

  test do
    system "#{bin}/mhap 2>&1 |grep MHAP"
  end
end
