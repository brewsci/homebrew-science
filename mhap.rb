class Mhap < Formula
  desc "MinHash Alignment Process"
  homepage "https://github.com/marbl/MHAP"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  url "https://github.com/marbl/MHAP/releases/download/v2.1/mhap-2.1.jar.gz"
  version "2.1"
  sha256 "1525fb366d469879859e8b1df0363ceae3da29e6f3232885601f2001a9998f41"

  head "https://github.com/marbl/MHAP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97058154bb3f888ff70eaba8afe64e0203a8392c5e4258a99f7594cb8b406eca" => :el_capitan
    sha256 "503271d1150b1958eb4db52a966ecb1ac22f6fbcf3969fc8e7bac8b66fe9cfb7" => :yosemite
    sha256 "a3d94e79ebacf136241f972d916938d742b7c605c76b5ea9c255adb998d8d651" => :mavericks
    sha256 "462540e798bf36be50fbaafcb62314f5c4a8e05c035292312476164cf5a64f92" => :x86_64_linux
  end

  def install
    prefix.install "mhap-#{version}.jar"
    bin.write_jar_script prefix/"mhap-#{version}.jar", "mhap"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mhap --help")
  end
end
