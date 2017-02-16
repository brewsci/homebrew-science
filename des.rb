class Des < Formula
  desc "Datalog Educational System"
  homepage "https://des.sourceforge.io"
  url "https://downloads.sourceforge.net/project/des/des/des4.2/DES4.2ACIDE0.17UnixesSWI.zip"
  version "4.2"
  sha256 "186d93b7c06f4dbe95ba46121464f3de013ee03d27f739b75322e7ba0df91fed"

  bottle do
    cellar :any_skip_relocation
    sha256 "9144e67f15116ab8fc75e0b2fd090e98160229b447467ad17bd735a1b23b5328" => :sierra
    sha256 "9144e67f15116ab8fc75e0b2fd090e98160229b447467ad17bd735a1b23b5328" => :el_capitan
    sha256 "9144e67f15116ab8fc75e0b2fd090e98160229b447467ad17bd735a1b23b5328" => :yosemite
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
