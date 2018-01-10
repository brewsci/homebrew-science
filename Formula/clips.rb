class Clips < Formula
  desc "Rule-based programming language for creating Expert Systems"
  homepage "http://www.clipsrules.net"
  url "https://downloads.sourceforge.net/project/clipsrules/CLIPS/6.30/clips_core_source_630.zip"
  version "6.30"
  sha256 "01555b257efae281199b82621ad5cc1106a395acc095b9ba66f40fe50fe3ef1c"

  bottle do
    cellar :any
    sha256 "ec94762baa2bfef3fa4db448ea4ada3d7f876733a8edc68a9128f878d0d9ed04" => :sierra
    sha256 "92882b712f7175ab121a87f5c6f12a2ecab6aa3fbfd67d3b59ca2703d48bbaca" => :el_capitan
    sha256 "82188bf3964afb67b0840ac3d41744be8d85c2a7056e8455e4f2ca2ea0d740df" => :yosemite
    sha256 "28af635f6aefb1a2f23dd668096c0f0b4c5b405a5cb767d13b35603a0fb8916c" => :x86_64_linux
  end

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
