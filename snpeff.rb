require 'formula'

class Snpeff < Formula
  homepage 'http://snpeff.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/snpeff/snpEff_v3_5_core.zip'
  version '3.5e'
  sha1 'edf0e0e0b50b9ec3821c445863dc2adae2486104'

  def install
    libexec.install "snpEff.jar", "SnpSift.jar", "snpEff.config"
    share.install "scripts", "galaxy"

    inreplace "snpeff", /^jardir=.*/, "jardir=#{libexec}"
    bin.install "snpeff"
  end

  def caveats
    puts <<-EOS.undent
      Download the human database using the command
          snpeff download -v GRCh37.74
      The databases will be installed in #{share}/java/data
    EOS
  end

  test do
    system "#{bin}/snpeff 2>&1 |grep -q snpEff"
  end
end
