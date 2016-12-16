class Bbtools < Formula
  desc "suite of Brian Bushnell's tools for manipulating reads"
  homepage "http://bbmap.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bbmap/BBMap_36.71.tar.gz"
  sha256 "663d8e2ab16560f86017bed623934beb043038f88fdf6d2350c43577b650dd8b"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "e23c718d29aeea4855cbdcd998de6e6dd7466bc40f8f9fdeeb7a71c64a855604" => :sierra
    sha256 "a4f734fd6435f9c20d5877f3dd0744b7b63a3f40d18865901d6753ab7d29ec46" => :el_capitan
    sha256 "599a320c668d1bf33a0b02a292efd2c75da111262db8bee6162da913d0dba7b0" => :yosemite
    sha256 "9f910f03dbc7a1127c912bf462d58fd0affc6d6b8b32a3b22b494c8a7e9116cc" => :x86_64_linux
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
