require 'formula'

class Htslib < Formula
  homepage 'https://github.com/samtools/htslib'
  url "https://github.com/samtools/htslib/archive/1.1.tar.gz"
  sha1 "206d1947eea6ad0b519e8c271702cdc281c976a7"
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
