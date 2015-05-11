class Mhap < Formula
  homepage "https://github.com/marbl/MHAP"
  # doi "10.1101/008003"
  # tag "bioinformatics"

  url "https://github.com/marbl/MHAP/releases/download/v1.0/mhap-1.0.tar.gz"
  sha256 "5f8293c3014213a9b911780d2b2f0af992fa0ce637528796cfa042a3bbf16d3b"

  head "https://github.com/marbl/MHAP.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "e39888765f401e11d86693ee5c3b998033155c2e443119d082ceac61f6b0c861" => :yosemite
    sha256 "43e32fd1b5b37a12fa1ff84e47a7c6fba25eaf9f25227e2aa13a18b0bfa34dfc" => :mavericks
    sha256 "c7babd4e75ace00f0d9cc4dd538b3ee2ae1eac2e5353b6bd02c1fa0577dd1ad6" => :mountain_lion
  end

  def install
    prefix.install "mhap-#{version}.jar", Dir["lib/*"]
    bin.write_jar_script prefix/"mhap-#{version}.jar", "mhap"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mhap --help")
  end
end
