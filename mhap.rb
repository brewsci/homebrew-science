class Mhap < Formula
  desc "MinHash Alignment Process"
  homepage "https://github.com/marbl/MHAP"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  url "https://github.com/marbl/MHAP/releases/download/v2.1.1/mhap-2.1.1.jar.gz"
  version "2.1.1"
  sha256 "66a5f34eb7ed23a4073edb44e3019d7ca16357951945b75a1825fd0c8763fdb3"
  head "https://github.com/marbl/MHAP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4869a9e52350d3c26eb8253c0bdaec69b8e7a4d4226242051aa8cc8e2795048" => :el_capitan
    sha256 "da477a2c0bbacf09f68f3c516a2eea0d72c42e711127869eccba360732324317" => :yosemite
    sha256 "5e625cbb37e5fc9e9f0050b9e5bc2f59daf0c30aaa23d03902c76d0fa2de6231" => :mavericks
  end

  def install
    prefix.install "mhap-#{version}.jar"
    bin.write_jar_script prefix/"mhap-#{version}.jar", "mhap"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mhap --help")
  end
end
