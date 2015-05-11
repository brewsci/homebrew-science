class Mhap < Formula
  homepage "https://github.com/marbl/MHAP"
  # doi "10.1101/008003"
  # tag "bioinformatics"

  url "https://github.com/marbl/MHAP/releases/download/v0.1/mhap-0.1.tar.gz"
  sha1 "c98096803c12d9d5e5281f0bf7809d909bccf185"

  head "https://github.com/marbl/MHAP.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "effd7e5aa3d11957c679f2049f93849d5b6d9d8f" => :yosemite
    sha1 "fb2198b8e91a6d7ba99ec84ecda4e4cf7329a91c" => :mavericks
    sha1 "af6b3d2dc212fc2e4a3ba0c4a81d1a0f7903593b" => :mountain_lion
  end

  def install
    prefix.install "mhap-0.1.jar", Dir["lib/*"]
    bin.write_jar_script prefix/"mhap-0.1.jar", "mhap"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mhap 2>&1", 1)
  end
end
