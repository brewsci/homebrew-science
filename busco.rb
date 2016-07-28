class Busco < Formula
  desc "Assess genome assembly completeness with single-copy orthologs"
  homepage "http://busco.ezlab.org"
  url "http://busco.ezlab.org/files/BUSCO_v1.22.tar.gz"
  sha256 "86088bbd2128ea04ad9e1b2ebd18201f4c79a48a161ba2593feb12abb8a2d0e2"
  # doi "10.1093/bioinformatics/btv351"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "1528092c980501dbcb700ae395153bc34780e337b36ebd5796625d5e8ef608f2" => :el_capitan
    sha256 "29483abacdd407ae5d7a5e3f19c2cabdb2efda398a29051df7d299f884afd713" => :yosemite
    sha256 "21a0045beef5494b79e9dd349258ef89451e18a5019097e5d5ce69e5c292d8a0" => :mavericks
  end

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
