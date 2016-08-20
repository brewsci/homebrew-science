class RnaStar < Formula
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  # doi "10.1093/bioinformatics/bts635"
  # tag "bioinformatics"

  url "https://github.com/alexdobin/STAR/archive/2.5.2b.tar.gz"
  version "2.5.2b"
  sha256 "f88b992740807ab10f2ac3b83781bf56951617f210001fab523f6480d0b546d9"
  head "https://github.com/alexdobin/STAR.git"

  bottle do
    cellar :any
    sha256 "b1581ed25ac7dd736acfbe4db632031b3885744bf5e71e7455734696d51e0a92" => :yosemite
    sha256 "98cec003bf3ee5f234a4e161f305fb30fb39eb4f53c2a7f5e24beb8a1facf2c3" => :mavericks
    sha256 "467ee2a2ffbe6c5346d744d43cbe0460ad3607756a37ea6702bd75611a333be8" => :mountain_lion
    sha256 "7e519c1b6d87f138bd0b88d6e6c8680af54fb3b2e4922992a0d66ff1fcef27cf" => :x86_64_linux
  end

  # Fix error: 'omp.h' file not found
  needs :openmp

  needs :cxx11

  def install
    ENV.cxx11
    cd "source" do
      progs = %w[STAR STARlong]
      targets = OS.mac? ? %w[STARforMacStatic STARlongForMacStatic] : progs
      system "make", *targets
      bin.install progs
    end
    pkgshare.install "extras"
    doc.install (buildpath/"doc").children
    mv "RELEASEnotes.md", "NOTES.md"
  end

  test do
    system "#{bin}/STAR", "--version"
    system "#{bin}/STARlong", "--version"
  end
end
