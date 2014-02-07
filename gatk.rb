require 'formula'

class Gatk < Formula
  tarball = Pathname.new("#{ENV["HOME"]}/Downloads/GenomeAnalysisTK-2.8-1.tar.bz2")
  unless tarball.readable?
    onoe <<-EOS.undent
      You must first download GATK from
      http://www.broadinstitute.org/gatk/download
      to #{tarball}
    EOS
    abort
  end

  homepage 'http://www.broadinstitute.org/gatk/index.php'
  url "file:#{tarball}"
  sha1 'd9a3ef19244ddf63dfb2a4eb954c83616b07cdab'

  def install
    java = share/'java'
    java.install 'GenomeAnalysisTK.jar'

    # Install a shell script to launch GATK.
    bin.mkdir
    open(bin / 'gatk', 'w') do |file|
      file.write <<-EOS.undent
        #!/bin/sh
        exec java -jar #{java}/GenomeAnalysisTK.jar "$@"
      EOS
    end
  end

  test do
    system 'gatk --version'
  end

  def caveats; <<-EOS.undent
    GATK requires Java 7.
    http://java.com/en/download/
    EOS
  end
end
