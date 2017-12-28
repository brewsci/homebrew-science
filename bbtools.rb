class Bbtools < Formula
  desc "suite of Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bbmap/BBMap_37.77.tar.gz"
  sha256 "3004c14dace43d35f4a89bf5fdaa5a2a9fab1630e173e801da9ea386cb166e96"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "4e59d491437184e9e725459a0a73b542e134e0fed361a08871f5e1ba7340437b" => :high_sierra
    sha256 "820b2e858d33b069c2470ecefaa694f76130d843449795f306f6abf95d5f46c6" => :sierra
    sha256 "7fe858e5bf8248998214fa898176e68401c2ddc957b795f0e911d445bc6d29bb" => :el_capitan
    sha256 "5c981c961b0f5a10f3b7dea200aa0f5072f67c9cb819df0f7440beb6062aceda" => :x86_64_linux
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
