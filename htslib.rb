require 'formula'

class Htslib < Formula
  homepage 'https://github.com/samtools/htslib'
  version '0.2.0-rc3'
  url "https://github.com/samtools/htslib/archive/#{version}.tar.gz"
  sha1 'a34fc68574d10754d9813fdb7ce4dad52da99d05'
  head 'https://github.com/samtools/htslib/archive/develop.tar.gz'

  def install
    system 'make'
    system 'make', 'install', 'prefix=' + prefix
  end
end
