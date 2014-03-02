require 'formula'

class Snpeff < Formula
  homepage 'http://snpeff.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/snpeff/snpEff_v3_5_core.zip'
  version '3.5c'
  sha1 '45a0f83b537cfd3c89e4c3b878b298f2614b0e4e'

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
          snpeff download -v GRCh37.74
      The databases will be installed in #{share}/java/data
    EOS
  end

  test do
    system "#{bin}/snpeff 2>&1 |grep -q snpEff"
  end
end
