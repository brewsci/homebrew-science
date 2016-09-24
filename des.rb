class Des < Formula
  desc "Datalog Educational System"
  homepage "http://des.sourceforge.net"
  url "https://downloads.sourceforge.net/project/des/des/des4.1/DES4.1ACIDE0.17UnixesSWI.zip"
  version "4.1"
  sha256 "dbc128a9b1b6a5e443a86bbdfb6ec6c8c748e888f574d22061098279f235aeea"

  bottle do
    cellar :any_skip_relocation
    sha256 "616212bc16b7d7b6e25f0695f97a87983e2d80f73ca11c7eba3a684ff8158f37" => :el_capitan
    sha256 "b58b1c2038549cbbe9853286f74052b8aa2f18ba502494219f1e79d3b39821f1" => :yosemite
    sha256 "6ee91cbfaa49703ce65b3599f45b1b5a7b8d16cd47d67fb80652cd12cddb32db" => :mavericks
  end

  depends_on :java => "1.6+"
  depends_on "swi-prolog"

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
