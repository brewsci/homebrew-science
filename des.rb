class Des < Formula
  desc "Datalog Educational System"
  homepage "https://des.sourceforge.io"
  url "https://downloads.sourceforge.net/project/des/des/des5.0.1/DES5.0.1ACIDE0.17UnixesSWI.zip"
  sha256 "101fb96710a14253fb2fc5c50cc8a7c8adc64670315638c7c2f1aba2144a6c7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "9144e67f15116ab8fc75e0b2fd090e98160229b447467ad17bd735a1b23b5328" => :sierra
    sha256 "9144e67f15116ab8fc75e0b2fd090e98160229b447467ad17bd735a1b23b5328" => :el_capitan
    sha256 "9144e67f15116ab8fc75e0b2fd090e98160229b447467ad17bd735a1b23b5328" => :yosemite
    sha256 "4b3022453364198951df49e5af99f7be812d0f9b5e770374d3bb2ffc21856775" => :x86_64_linux
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
