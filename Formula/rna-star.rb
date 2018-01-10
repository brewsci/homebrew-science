class RnaStar < Formula
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  # doi "10.1093/bioinformatics/bts635"
  # tag "bioinformatics"

  url "https://github.com/alexdobin/STAR/archive/2.5.3a.tar.gz"
  version "2.5.3a"
  sha256 "2a258e77cda103aa293e528f8597f25dc760cba188d0a7bc7c9452f4698e7c04"
  head "https://github.com/alexdobin/STAR.git"

  bottle do
    sha256 "9891475ea134f632ff3679bad0da0106788e1b973f4d599abafe02be9a96335b" => :sierra
    sha256 "14f4500e87c9b01a4c34dcdbb5ba7bc23f35de2ff314aea8c66c5e41854c5566" => :el_capitan
    sha256 "7e09fa7c1f504268451cbfc96e71d8e634acfd187baee282159dc28d5f1a1e53" => :yosemite
    sha256 "37b3887f15a4dacf602748923b8bb401a95d261a1a08a1850c4b1ce3547c3403" => :x86_64_linux
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
