require 'formula'

class AbyssExplorer < Formula
  homepage 'http://www.bcgsc.ca/platform/bioinfo/software/abyss-explorer'
  url 'http://www.bcgsc.ca/downloads/abyss-explorer/abyss-explorer-1.3.4/abyss-explorer-1.3.4.zip'
  sha1 'f9b41c5c9d458cf46399571de9c6070b04a2e8b5'

  def install
    libexec.install 'AbyssExplorer.jar', 'lib'
    (bin / 'abyss-explorer').write <<-EOS.undent
      #!/bin/sh
      set -eu
      exec java -jar #{libexec}/AbyssExplorer.jar "$@"
    EOS
  end
end
