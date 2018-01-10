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
    sha256 "9adbb7bd7ecb554569963c18b240943d7ac688e33a134abbd04928194f003bd2" => :sierra
    sha256 "a646dc8d072bc89d60771f7a38d55c599aea25f4a45c057cf4774e99f678d365" => :el_capitan
    sha256 "165943433f514997de36880f545b9d3d4b1ed0f196c8f4fd9e5bb10de4b9dc8c" => :yosemite
    sha256 "c1cdeee8009b8d12e7e841873fb4b433fb45bed634aa3091f7c444d2c8a346cf" => :x86_64_linux
  end

  def install
    prefix.install "mhap-#{version}.jar"
    bin.write_jar_script prefix/"mhap-#{version}.jar", "mhap"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mhap --help")
  end
end
