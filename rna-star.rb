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
    sha256 "2d73757478b6a224e266be8e256c9e390216663c6ce15ea1e8c31bb6a4df02cb" => :sierra
    sha256 "816d772d1f9b4e50c9057e8e67427aea0f13d41b458dbbb7fc6af22e22e80704" => :el_capitan
    sha256 "9d3355cff6dfcc663bfa28e155b74888508d5cf34554098696d367c0cd2e1811" => :yosemite
    sha256 "69221e01050b5ca54fb6900139f9ccd30b3142c151f75b81a0b8464fdb779907" => :x86_64_linux
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
