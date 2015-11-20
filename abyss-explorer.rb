class AbyssExplorer < Formula
  desc "Visualize genome sequence assemblies"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss-explorer"
  #doi "10.1109/TVCG.2009.116"
  #tag "bioinformatics"

  url "http://www.bcgsc.ca/downloads/abyss-explorer/abyss-explorer-1.3.4/abyss-explorer-1.3.4.zip"
  sha1 "f9b41c5c9d458cf46399571de9c6070b04a2e8b5"

  bottle do
    cellar :any
    sha256 "137b53b687eda6799a2cd2d36c6ac71b10c430e95340a89805f0cf3b4aada01b" => :yosemite
    sha256 "f8939d4e7d31f8f8e8c8167761760276bd4bfbc9aa3ae9885e76a977c1d19f37" => :mavericks
    sha256 "b22ed1f840798813fb9e405cbc6047ca50d5aa3fe967da228d33c80d6bef4606" => :mountain_lion
  end

  def install
    libexec.install "AbyssExplorer.jar", "lib"
    (bin / "abyss-explorer").write <<-EOS.undent
      #!/bin/sh
      set -eu
      exec java -jar #{libexec}/AbyssExplorer.jar "$@"
    EOS
  end
end
