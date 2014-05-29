require 'formula'

class Htslib < Formula
  homepage 'https://github.com/samtools/htslib'
  version '0.2.0-rc8'
  url "https://github.com/samtools/htslib/archive/#{version}.tar.gz"
  sha1 'c6db4573fba0cd189130add7d4d86c7d17295f34'
  head 'https://github.com/samtools/htslib.git'

  conflicts_with "tabix", :because => "both htslib and tabix install bin/tabix"

  def install
    # Write version to avoid 0.0.1 version information output from Makefile
    system "echo '#define HTS_VERSION \"#{version}\"' > version.h"
    system 'make'
    system 'make', 'install', 'prefix=' + prefix
    (include/'htslib').install 'version.h'
  end
end
