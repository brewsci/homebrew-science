require 'formula'

class Htslib < Formula
  homepage 'https://github.com/samtools/htslib'
  version '0.2.0-rc6'
  url "https://github.com/samtools/htslib/archive/#{version}.tar.gz"
  sha1 '08cd1cb79321b3928167c777aca8fa473493fca9'
  head 'https://github.com/samtools/htslib/archive/develop.tar.gz'

  def patches
    # Makefile: Add razf.o to LIBHTS_OBJS
    # https://github.com/samtools/htslib/pull/74
    'https://github.com/sjackman/htslib/commit/d61a8e65390a6f1056fedc891ae0144b55e7b104.patch'
  end

  def install
    system 'make'
    system 'make', 'install', 'prefix=' + prefix
    (include/'htslib').install 'version.h'
  end
end
