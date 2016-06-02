class AbyssExplorer < Formula
  desc "Visualize genome sequence assemblies"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss-explorer"
  # doi "10.1109/TVCG.2009.116"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/downloads/abyss-explorer/abyss-explorer-1.3.4/abyss-explorer-1.3.4.zip"
  sha256 "fa4197c985ae9e66a01b4d3db4e6211f4e84444bc31deaf4c1aa352431ae6491"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "fea28ec5a740dbe3e30bef31ef261626ab37b6c62c7417cb84649547c00ef8bd" => :sierra
    sha256 "8399757c2f8ba384cca623a2eb93ccdd727d6fc564c5a44f4a0a1815a9009b66" => :el_capitan
    sha256 "1e9a7715de74ed13051083c072a2fe0f5134c86c2ad2f9446c3bc0b245a305eb" => :yosemite
    sha256 "420ff6af90cb029ec07869c8f3871520de35109bafefead83477595e2073acb4" => :mavericks
    sha256 "3257b5db71026d508bec3504b61434d92264600cd9cbcb712a4fe5ff8c4f30cb" => :x86_64_linux
  end

  def install
    libexec.install "AbyssExplorer.jar", "lib"
    (bin / "abyss-explorer").write <<-EOS.undent
      #!/bin/sh
      set -eu
      exec java -jar #{libexec}/AbyssExplorer.jar "$@"
    EOS
  end

  test do
    system "abyss-explorer", "--version"
  end
end
