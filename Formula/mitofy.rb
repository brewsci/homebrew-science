class Mitofy < Formula
  homepage "https://dogma.ccbb.utexas.edu/mitofy/"
  # doi "10.1093/molbev/msq029"
  # tag "bioinformatics"

  url "https://dogma.ccbb.utexas.edu/mitofy/mitofy.tgz"
  version "20120322"
  sha256 "29e73b0f0a09e698209809081cc0de1ef0ee7e3cf9ae873b01504911025bb244"

  bottle do
    cellar :any
    sha256 "3194d6f95b55e17e7e2099583d2590df400531c82d17333ca94b1f892ea0e74b" => :yosemite
    sha256 "5d8abbd913f8881787cba13c0b22f5fe27c6e3104a1432896edfe075f866fa37" => :mavericks
    sha256 "a8641e8824c35651d7062aa3e403aafeaf038ca62011f8fa93d9849446178942" => :mountain_lion
    sha256 "674f07fce66705f83ce55094257a8a119824a0da6ad3e1bde72b97b7120a28ae" => :x86_64_linux
  end

  # Includes vendored dependencies of BLAST 2.2.25 and tRNAscan-SE 1.4 compiled for Mac OS.

  def install
    prefix.install Dir["*"]

    # Install a shell script to launch mitofy.
    bin.mkdir
    open(bin/"mitofy", "w") do |file|
      file.write <<-EOS.undent
        #!/bin/sh
        exec perl -I#{prefix}/annotate #{prefix}/annotate/mitofy.pl "$@"
      EOS
    end
  end

  def caveats; <<-EOS.undent
    To use the Mitofy web app, run the following commands:
      sudo cp #{opt_prefix}/cgi/* /Library/WebServer/CGI-Executables/
      sudo mkdir /Library/WebServer/CGI-Executables/cgi_out
      sudo chown _www:_www /Library/WebServer/CGI-Executables/cgi_out
      sudo apachectl start
    To start the web server Apache when your computer boots, run this command:
      sudo defaults write /System/Library/LaunchDaemons/org.apache.httpd Disabled -bool false
    Annotation results will be stored in
      /Library/WebServer/CGI-Executables/cgi_out
    EOS
  end

  test do
    system "#{bin}/mitofy"
  end
end
