class Mhap < Formula
  desc "MinHash Alignment Process"
  homepage "https://github.com/marbl/MHAP"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  url "https://github.com/marbl/MHAP/releases/download/v2.0/mhap-2.0.tar.gz"
  sha256 "0c94d0a3a2cbc9151d99a83e813865e5cc443d23dc33ea5622ca876ca46ec6c7"

  head "https://github.com/marbl/MHAP.git"

  bottle do
    cellar :any
    sha256 "04759dd37c8096f22e57b8ce8022292efe112013e9d59c51269469e641945161" => :yosemite
    sha256 "69455089478902596629aa009ac76f98e7779fc29dbf7b069ca2f6060092ae47" => :mavericks
    sha256 "adbf98a0bf965072416d2c0aaeaec677b921f9455904c62589536ed2d22c83b5" => :mountain_lion
  end

  def install
    prefix.install "mhap-#{version}.jar"
    bin.write_jar_script prefix/"mhap-#{version}.jar", "mhap"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mhap --help")
  end
end
