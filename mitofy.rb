require 'formula'

class Mitofy < Formula
  homepage 'http://dogma.ccbb.utexas.edu/mitofy/'
  url 'http://dogma.ccbb.utexas.edu/mitofy/mitofy.tgz'
  sha1 'd55569b6ab186b1e50012f2ba8aa984a4ee2a34e'
  version '20120322'

  def install
    libexec.install Dir['*']

    # Install a shell script to launch mitofy.
    bin.mkdir
    open(bin / 'mitofy', 'w') do |file|
      file.write <<-EOS.undent
        #!/bin/sh
        exec perl -I#{libexec}/annotate #{libexec}/annotate/mitofy.pl "$@"
      EOS
    end
  end

  test do
    system 'mitofy'
  end
end
