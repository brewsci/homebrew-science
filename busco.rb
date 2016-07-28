class Busco < Formula
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "http://busco.ezlab.org"
  url "http://busco.ezlab.org/files/BUSCO_v1.22.tar.gz"
  sha256 "86088bbd2128ea04ad9e1b2ebd18201f4c79a48a161ba2593feb12abb8a2d0e2"
  # doi "10.1093/bioinformatics/btv351"
  # tag "bioinformatics"

  depends_on :python

  def install
    bin.install "BUSCO_v#{version}.py" => "busco"
    inreplace bin/"busco", "#!/bin/python", "#!/usr/bin/env python"
    doc.install Dir["*"]
  end

  test do
    system "#{bin}/busco", "--help"
  end
end
