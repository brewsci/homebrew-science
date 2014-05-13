require 'formula'

class Htslib < Formula
  homepage 'https://github.com/samtools/htslib'
  version '0.2.0-rc8'
  url "https://github.com/samtools/htslib/archive/#{version}.tar.gz"
  sha1 'c6db4573fba0cd189130add7d4d86c7d17295f34'
  head 'https://github.com/samtools/htslib.git'

  patch do
    # Makefile: Add razf.o to LIBHTS_OBJS
    # https://github.com/samtools/htslib/pull/74
    url "https://github.com/sjackman/htslib/commit/d61a8e65390a6f1056fedc891ae0144b55e7b104.diff"
    sha1 "fe452b100cec82b3014d551a33a7c01404e45c34"
  end

  def install
    # Write version to avoid 0.0.1 version information output from Makefile
    system "echo '#define HTS_VERSION \"#{version}\"' > version.h"
    system 'make'
    system 'make', 'install', 'prefix=' + prefix
    (include/'htslib').install 'version.h'
  end
end
