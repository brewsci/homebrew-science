require 'formula'

class Snpeff < Formula
  homepage 'http://snpeff.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/snpeff/snpEff_v3_3_core.zip'
  version '3.3'
  sha1 '700d4dfbd6b02c7a5c0284730e294174d1cd3684'

  def install
    java = share / 'java'
    java.install 'snpEff.jar', 'SnpSift.jar', 'snpEff.config'
    # Install a shell script to launch snpEff.
    bin.mkdir
    open(bin / 'snpeff', 'w') do |file|
      file.write <<-EOS.undent
        #!/bin/sh
        exec java -jar #{java}/snpEff.jar "$@" -c #{java}/snpEff.config
      EOS
    end
  end

  def caveats
    puts <<-EOS.undent
      Download the human database using the command
          snpeff download -v GRCh37.71
      The databases will be installed in ~/snpEff/data
    EOS
  end

  test do
    system "#{bin}/snpeff 2>&1 |grep -q snpEff"
  end
end
