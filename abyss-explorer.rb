class AbyssExplorer < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss-explorer"
  #doi "10.1109/TVCG.2009.116"
  #tag "bioinformatics"

  url "http://www.bcgsc.ca/downloads/abyss-explorer/abyss-explorer-1.3.4/abyss-explorer-1.3.4.zip"
  sha1 "f9b41c5c9d458cf46399571de9c6070b04a2e8b5"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "054c74139e044f50d8bf05c7a08b2a8c8628c700" => :yosemite
    sha1 "8f12e9d104f5c43f87690d81230cd922e1766aaf" => :mavericks
    sha1 "d0065aca6f517ddd003f6c94b25f79ca9af7c731" => :mountain_lion
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
