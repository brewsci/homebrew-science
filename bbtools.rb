class Bbtools < Formula
  desc "suite of Brian Bushnell's tools for manipulating reads"
  homepage "http://bbmap.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bbmap/BBMap_36.71.tar.gz"
  sha256 "663d8e2ab16560f86017bed623934beb043038f88fdf6d2350c43577b650dd8b"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc6caa710db30124f9f3bc829b90e961fead12e514c6c85cf5eb02155d39e289" => :el_capitan
    sha256 "cefdee5a7bff7cbc25583a423aeed79bd78871093d8dc796513b324c95d0b142" => :yosemite
    sha256 "64937d61419187c1ee007a6d96deec813984ecbeec67d6088f9f34d1f5459d7b" => :mavericks
    sha256 "c248889cd98f335fe7e251635ce86763e9b9fa77644f5c67e482fb36208f9bf0" => :x86_64_linux
  end

  depends_on :java => "1.7+"
  depends_on "pigz" => :optional

  def install
    if OS.mac?
      system "make", "--directory=jni", "-f", "makefile.osx"
    elsif OS.linux?
      system "make", "--directory=jni", "-f", "makefile.linux"
    end
    prefix.install %w[current jni resources]
    # shell scripts look for ./{current,jni,resources} files, so keep shell scripts
    # in ./#{prefix} but place symlinks in the ../bin dir for brew to export #{bin}
    mkdir "#{bin}"
    prefix.install Dir["*.sh"]
    bin.install_symlink Dir["#{prefix}/*.sh"]
    doc.install %w[license.txt README.md docs/changelog.txt docs/Legal.txt docs/readme.txt docs/ToolDescriptions.txt]
  end

  test do
    system "#{bin}/bbmap.sh 2>&1 | grep -q 'bbushnell@lbl.gov'"
    system "#{bin}/bbduk.sh", "in=#{prefix}/resources/sample1.fq.gz", "in2=#{prefix}/resources/sample2.fq.gz", "out=/tmp/R1.fastq.gz", "out2=/tmp/R2.fastq.gz", "ref=#{prefix}/resources/phix174_ill.ref.fa.gz", "overwrite=true", "k=31", "hdist=1"
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1", 0)
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1", 0)
  end
end
