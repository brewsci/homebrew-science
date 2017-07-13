class Clips < Formula
  desc "Rule-based programming language for creating Expert Systems"
  homepage "http://www.clipsrules.net"
  url "https://downloads.sourceforge.net/project/clipsrules/CLIPS/6.30/clips_core_source_630.zip"
  version "6.30"
  sha256 "01555b257efae281199b82621ad5cc1106a395acc095b9ba66f40fe50fe3ef1c"

  def install
    system "make", "-f", "../makefiles/makefile.gcc", "-C", "core"
    bin.install "core/clips"
  end

  test do
    IO.popen("#{bin}/clips", "w") do |pipe|
      pipe.puts "(exit)\n"
      pipe.close_write
    end
  end
end
