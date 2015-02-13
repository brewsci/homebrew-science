class Bcftools < Formula
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/archive/1.2.tar.gz"
  sha1 "fa6280426ae50acd70b98aa6acce3d0375c419e9"
  head "https://github.com/samtools/bcftools.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "8cfb381d2fb4521a3750084a6c67790a0b248ffa" => :yosemite
    sha1 "3a216df0a0f34ab4187d082523b3c0bfef11eace" => :mavericks
    sha1 "628e8bd74cd72548fb3907cb75e1e9bd65e512c3" => :mountain_lion
  end

  depends_on "htslib"

  def install
    inreplace "Makefile", "include $(HTSDIR)/htslib.mk", ""
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
