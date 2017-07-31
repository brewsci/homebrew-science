class Snap < Formula
  desc "Gene prediction tool"
  homepage "http://korflab.ucdavis.edu/software.html"
  # doi "10.1186/1471-2105-5-59"
  # tag "bioinformatics"

  url "http://korflab.ucdavis.edu/Software/snap-2013-11-29.tar.gz"
  sha256 "e2a236392d718376356fa743aa49a987aeacd660c6979cee67121e23aeffc66a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "71cb5dea75c27f6e4794e27b8e07af673465f6285b6a9b02ff01d9a51108c9bc" => :el_capitan
    sha256 "6c6690240b7363db44f12dcb42bd8e71b00c4d6f4c543bc1dd6d8197e9a2b161" => :yosemite
    sha256 "8844eab0a698e205b665ffe48fb5eaa18c30f83e1e7ed052232791a003ffc373" => :mavericks
    sha256 "346c45e5bfe70992e75da928dace257ee6a37acb083e717bb7b2a96b8210d4db" => :x86_64_linux
  end

  def install
    system "make"
    bin.install %w[exonpairs fathom forge hmm-info snap]
    bin.install Dir["*.pl"]
    doc.install %w[00README LICENSE example.zff]
    prefix.install %w[DNA HMM Zoe]
  end

  def caveats; <<-EOS.undent
      Set the ZOE environment variable:
        export ZOE=#{opt_prefix}
    EOS
  end

  test do
    system "#{bin}/snap", "-help"
  end
end
