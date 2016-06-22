class Des < Formula
  desc "Datalog Educational System"
  homepage "http://des.sourceforge.net"
  url "https://downloads.sourceforge.net/project/des/des/des4.1/DES4.1ACIDE0.17UnixesSWI.zip"
  version "4.1"
  sha256 "dbc128a9b1b6a5e443a86bbdfb6ec6c8c748e888f574d22061098279f235aeea"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecbf0202586dbf24012a34cf4da6df7bd987455aa5dd135fe44b2d3224a09ae8" => :el_capitan
    sha256 "d0c76090f91fd4c41c37cd56eb5be64ebe9fdbd0b7896e65ad66c7adfe3cfafc" => :yosemite
    sha256 "0770a2500591ac894e6bc300acfa2ff60d7e7dd27f94a4f46d1c2b6bfe227752" => :mavericks
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
