class Mhap < Formula
  homepage "https://github.com/marbl/MHAP"
  # doi "10.1101/008003"
  # tag "bioinformatics"

  url "https://github.com/marbl/MHAP/releases/download/v1.5b1/mhap-1.5b1.tar.gz"
  sha256 "fa3a7fbf370d61deedb1866cf141ddf6b7538b05009be1fd8f2cbd55ff28ca99"

  head "https://github.com/marbl/MHAP.git"

  bottle do
    cellar :any
    sha256 "04759dd37c8096f22e57b8ce8022292efe112013e9d59c51269469e641945161" => :yosemite
    sha256 "69455089478902596629aa009ac76f98e7779fc29dbf7b069ca2f6060092ae47" => :mavericks
    sha256 "adbf98a0bf965072416d2c0aaeaec677b921f9455904c62589536ed2d22c83b5" => :mountain_lion
  end

  def install
    prefix.install "mhap-#{version}.jar", Dir["lib/*"]
    bin.write_jar_script prefix/"mhap-#{version}.jar", "mhap"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mhap --help")
  end
end
