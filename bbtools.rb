class Bbtools < Formula
  desc "suite of Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bbmap/BBMap_37.02.tar.gz"
  sha256 "f0af3c27ee93ea89625d227b6c0c3eb9e1bca427f0f8ca9085f691f5dd8835c2"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "1094614ff2647ea6d0f72fecc08f6101704c95658713d1a9a4fcbc3822c5132c" => :sierra
    sha256 "58f7446c90e121ac8d187b2708016ba9ed7d953737dcd4069e091de0c015a904" => :el_capitan
    sha256 "7db32828cb0b94cc497223a5e1262e6abc2a3d4e6a2de617e88261975ac97e31" => :yosemite
    sha256 "a3f0392601fc65a83e5686c8efcdd2c992251a9b7e6d35caf52733ebd3e4b370" => :x86_64_linux
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
    bin.mkpath
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
