require 'formula'

class Snpeff < Formula
  homepage 'http://snpeff.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/snpeff/snpEff_v4_1_core.zip'
  version '4.1'
  sha1 "83e1d2e32bfc8b9104f1856e70f8b1112fa290ab"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "d663e17fc44066a66ae8f05a99d2b7e4fd1fdda8" => :yosemite
    sha1 "fdbf0db244297f35281850bb2381d7abbba0392e" => :mavericks
    sha1 "25acc2120b891e10c79530662578e24dc6ff20b8" => :mountain_lion
  end

  def install
    inreplace "scripts/snpEff" do |s|
      s.gsub! /^jardir=.*/, "jardir=#{libexec}"
      s.gsub! "${jardir}/snpEff.config", "#{share}/snpEff.config"
    end

    bin.install "scripts/snpEff"
    libexec.install "snpEff.jar", "SnpSift.jar"
    share.install "snpEff.config", "scripts", "galaxy"
  end

  def caveats; <<-EOS.undent
      Download the human database using the command
          snpEff download -v GRCh38.76
      The databases will be installed in #{share}/data
    EOS
  end

  test do
    system "#{bin}/snpEff 2>&1 |grep -q snpEff"
  end
end
