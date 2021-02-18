class Des < Formula
  desc "Datalog Educational System"
  homepage "https://des.sourceforge.io"
  url "https://downloads.sourceforge.net/project/des/des/des5.0.1/DES5.0.1ACIDE0.17UnixesSWI.zip"
  sha256 "101fb96710a14253fb2fc5c50cc8a7c8adc64670315638c7c2f1aba2144a6c7f"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-science"
    sha256 cellar: :any_skip_relocation, high_sierra:  "6cb0f6aa606566fa735dda9524c900e3e51602dafa6cad01e821cabf5a3c1b7e"
    sha256 cellar: :any_skip_relocation, sierra:       "6cb0f6aa606566fa735dda9524c900e3e51602dafa6cad01e821cabf5a3c1b7e"
    sha256 cellar: :any_skip_relocation, el_capitan:   "6cb0f6aa606566fa735dda9524c900e3e51602dafa6cad01e821cabf5a3c1b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b4c1c5e10fdc28d1a9795fd43893235df6237f69243421ba00c1d33c6438c510"
  end

  depends_on "openjdk"
  depends_on "swi-prolog"

  def shim_script
    <<~EOS
      #!/usr/bin/env bash
      cd #{libexec}
      swipl des.pl
    EOS
  end

  def jar_script(target_jar)
    <<~EOS
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

  def caveats
    <<~EOS
      The executable for the console version of DES is
          #{bin}/des

      The executable to launch the GUI version of DES is
          #{bin}/des-gui
    EOS
  end

  test do
    cmd = <<~EOS
      des << 'END'
      /pretty_print off
      /version
      /exit
      END
    EOS
    assert_match "Info: DES version #{version}", shell_output(cmd)
  end
end
