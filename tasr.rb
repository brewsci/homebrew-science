class Tasr < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/tasr"
  #doi "10.1371/journal.pone.0019816"
  #tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/tasr/releases/1.5.1/tasr_v1-5-1.tar.gz"
  version "1.5.1"
  sha1 "98f3b2207a5e7a1904cc858dec6614677c6b38df"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "3a0971056c247c128cdf5d9e358041ea52320f51" => :yosemite
    sha1 "cc104749c8987de39ad6dd8f20c03f450f16f1b8" => :mavericks
    sha1 "e5b7c109d35f4d204377f0950c5827ddf622bc2a" => :mountain_lion
  end

  def install
    bin.install "TASR"
    doc.install "TASR.readme"
    prefix.install "test", "tools"
  end

  test do
    system "#{bin}/tasr |grep tasr"
  end
end
