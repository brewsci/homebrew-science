require 'formula'

class Bedops < Formula
  homepage 'https://code.google.com/p/bedops/'
  url 'https://bedops.googlecode.com/files/bedops_macosx_intel_fat-v2.0.0b.tgz'
  sha1 '4ca3844e626dae4b16a710078a3a37994fab0e69'

  def install
    bin.install 'bedops'
    libexec.install %W(bam2bed bam2starch bbms bbms.py bedextract
      bedmap closest-features gff2bed gtf2bed sam2bed sam2starch
      sort-bed starch starchcat starchcluster starchcluster.gnu_parallel
      unstarch vcf2bed wig2bed)
  end

  def caveats
    <<-EOS.undent
      `bedops` is installed in
        #{bin}
      and other executables are installed in
        #{libexec}
    EOS
  end

  test do
    system 'bedops', '--help'
  end
end
