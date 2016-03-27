class Mhap < Formula
  desc "MinHash Alignment Process"
  homepage "https://github.com/marbl/MHAP"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  url "https://github.com/marbl/MHAP/releases/download/v2.0/mhap-2.0.tar.gz"
  sha256 "0c94d0a3a2cbc9151d99a83e813865e5cc443d23dc33ea5622ca876ca46ec6c7"

  head "https://github.com/marbl/MHAP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97058154bb3f888ff70eaba8afe64e0203a8392c5e4258a99f7594cb8b406eca" => :el_capitan
    sha256 "503271d1150b1958eb4db52a966ecb1ac22f6fbcf3969fc8e7bac8b66fe9cfb7" => :yosemite
    sha256 "a3d94e79ebacf136241f972d916938d742b7c605c76b5ea9c255adb998d8d651" => :mavericks
  end

  def install
    prefix.install "mhap-#{version}.jar"
    bin.write_jar_script prefix/"mhap-#{version}.jar", "mhap"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mhap --help")
  end
end
