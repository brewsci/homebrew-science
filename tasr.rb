require "formula"

class Tasr < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/tasr"
  #doi "10.1371/journal.pone.0019816"
  #tag "bioinformatics"
  url "http://www.bcgsc.ca/platform/bioinfo/software/tasr/releases/1.5.1/tasr_v1.5.1-tar.gz"
  version "1.5.1"
  sha1 "d12cdd3e1812f1ca0ade30d242bcb877eb763196"

  def install
    system "tar xf tasr_v#{version}-tar"
    cd "tasr_v#{version}" do
      bin.install "TASR"
      doc.install "TASR.readme"
      prefix.install "test", "tools"
    end
  end

  test do
    system "tasr |grep tasr"
  end
end
