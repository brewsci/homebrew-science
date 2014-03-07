require 'formula'

class Bcftools < Formula
  homepage 'https://github.com/samtools/bcftools'
  version '0.2.0-rc6'
  url "https://github.com/samtools/bcftools/archive/#{version}.tar.gz"
  sha1 '544fb9f186960e55b492e5785023220fb3e004ea'
  depends_on 'chapmanb/cbl/htslib'

  def install
    inreplace 'Makefile', 'include $(HTSDIR)/htslib.mk', ''
    htslib = Formula.factory('htslib').opt_prefix
    inreplace 'Makefile' do |s|
      s.change_make_var! 'HTSDIR', htslib
      s.change_make_var! 'HTSLIB', "#{htslib}/lib/libhts.a"
      s.change_make_var! 'INCLUDES', "-I. -I#{htslib}/include"
      s.gsub! '$(HTSDIR)/htslib/', '$(HTSDIR)/include/htslib/'
      s.gsub! 'all:$(PROG) plugins', 'all:$(PROG)'
    end
    # Write version since current Makefile logic fails on non-gmake systems
    system "echo '#define BCFTOOLS_VERSION \"#{version}\"' > version.h"
    system 'make'
    system 'make', 'install', 'prefix=' + prefix
  end

  test do
    system 'bcftools'
  end
end
