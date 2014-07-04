require 'formula'

class Htslib < Formula
  homepage 'https://github.com/samtools/htslib'
  version '0.2.0-rc10'
  url "https://github.com/samtools/htslib/archive/#{version}.tar.gz"
  sha1 '1545c910d585ffe7dbe4a4a1bbcb62efb46f6819'
  head 'https://github.com/samtools/htslib.git'

  conflicts_with "tabix", :because => "both htslib and tabix install bin/tabix"

  def install
    # Write version to avoid 0.0.1 version information output from Makefile
    system "echo '#define HTS_VERSION \"#{version}\"' > version.h"
    system 'make'
    system 'make', 'install', 'prefix=' + prefix
  end

  test do
    system "#{bin}/bgzip --help 2>&1 |grep bgzip"
    system "#{bin}/tabix --help 2>&1 |grep tabix"
  end
end
