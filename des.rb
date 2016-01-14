class Des < Formula
  desc "Datalog Educational System"
  homepage "http://des.sourceforge.net"
  url "https://downloads.sourceforge.net/project/des/des/des3.12/DES3.12ACIDE0.17UnixesSWI.zip"
  version "3.12"
  sha256 "1cba61cfbe0d64e4ccf425691b650a352e43047bef4622262acd66b8eb3d62d5"

  depends_on :java => "1.6+"
  depends_on "homebrew/x11/swi-prolog"

  def shim_script; <<-EOS.undent
      #!/usr/bin/env bash
      cd #{libexec}
      swipl des.pl
    EOS
  end

  def jar_script(target_jar); <<-EOS.undent
      #!/bin/bash
      cd #{libexec}
      exec java -jar #{target_jar} "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    # Fix script permissions (required by des-gui)
    chmod 0755, libexec/"des"
    # DES can be executed only from inside its directory
    (bin+"des").write shim_script
    (bin+"des-gui").write jar_script("des_acide.jar")
  end

  def caveats; <<-EOS.undent
    The executable for the console version of DES is
        #{bin}/des

    The executable to launch the GUI version of DES is
        #{bin}/des-gui
    EOS
  end

  test do
    cmd = <<-EOS.undent
    des << 'END'
    /pretty_print off
    /version
    /exit
    END
    EOS
    assert_match "Info: DES version #{version}", shell_output(cmd)
  end
end
