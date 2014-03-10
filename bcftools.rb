require "formula"

class Bcftools < Formula
  homepage "https://github.com/samtools/bcftools"
  version "0.2.0-rc6"
  url "https://github.com/samtools/bcftools/archive/#{version}.tar.gz"
  sha1 "544fb9f186960e55b492e5785023220fb3e004ea"
  head "https://github.com/samtools/bcftools.git"

  depends_on "htslib"

  def install
    inreplace "Makefile", "include $(HTSDIR)/htslib.mk", ""
    inreplace "Makefile", "$(HTSDIR)/version.h", "$(HTSDIR)/htslib/version.h"
    htslib = Formula["htslib"].opt_prefix
    # Write version to avoid 0.0.1 version information output from Makefile
    system "echo '#define BCFTOOLS_VERSION \"#{version}\"' > version.h"
    system *%W[make bcftools HTSDIR=#{htslib}/include HTSLIB=#{htslib}/lib/libhts.a]
    system *%W[make install prefix=#{prefix} HTSDIR=#{htslib}/include HTSLIB=#{htslib}/lib/libhts.a]
  end

  test do
    system "#{bin}/bcftools 2>&1 |grep -q bcftools"
  end
end
