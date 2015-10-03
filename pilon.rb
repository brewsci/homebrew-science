class Pilon < Formula
  desc "Improve draft assemblies and find variation"
  homepage "https://github.com/broadinstitute/pilon/wiki"
  bottle do
    cellar :any_skip_relocation
    sha256 "ce33601bd3a361ecba9df239a5488fd8b173d6a2411ee04ff5f18ae14db28ad0" => :el_capitan
    sha256 "68467efec02028a8dfdbf47c5d4fa69fd27303c97cd87f104f7028f16b68206b" => :yosemite
    sha256 "29d41de34aaede7601b9238deb672417e26733e3810cd042fe7b4fa6bcd8a964" => :mavericks
  end

  # tag "bioinformatics"
  # doi "10.1371/journal.pone.0112963"

  url "https://github.com/broadinstitute/pilon/releases/download/v1.13/pilon-1.13.jar"
  sha256 "c6195a054acbc76afc457e6a7615f75c91adc28faeb7b8738ee2b65309b0bbe3"

  depends_on :java

  def install
    opts = "-mx1000m -ms20m"
    jar = "pilon-1.13.jar"
    java = share/"java"
    java.install jar
    bin.write_jar_script java/jar, "pilon", opts
  end

  test do
    assert_match "Pilon version", shell_output("pilon --help")
  end
end
