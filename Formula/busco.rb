class Busco < Formula
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "http://busco.ezlab.org"
  url "http://busco.ezlab.org/v1/files/BUSCO_v1.22.tar.gz"
  sha256 "86088bbd2128ea04ad9e1b2ebd18201f4c79a48a161ba2593feb12abb8a2d0e2"
  revision 1
  # doi "10.1093/bioinformatics/btv351"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "146e3caa137d45be78e03aae3b832e8c6bcbeeeb7919505f7d4f3cc5842c8cf9" => :el_capitan
    sha256 "12f4fe1bf7d9199aa2ff5f9579051cc741fbd451ae801943caa3df3baeafa8dd" => :yosemite
    sha256 "c4136ee88129c555fe0468d8e600e82c25a9b505c6a7199c74987fb8b3f71861" => :mavericks
    sha256 "1f0f9d7ae6d7650fc307bef6b1520c87e1d7c3d839a508e021bba6e5c75cad3d" => :x86_64_linux
  end

  depends_on :python
  depends_on "augustus" => :recommended
  depends_on "blast" => :recommended
  depends_on "emboss" => :recommended
  depends_on "hmmer" => :recommended

  def install
    inreplace "BUSCO_v#{version}.py", "#!/bin/python", "#!/usr/bin/env python"
    bin.install "BUSCO_v#{version}.py"
    bin.install_symlink "BUSCO_v#{version}.py" => "busco"
    doc.install Dir["*"]
  end

  test do
    system "#{bin}/busco", "--help"
  end
end
