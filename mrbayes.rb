class Mrbayes < Formula
  homepage "http://mrbayes.sourceforge.net/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg180"

  url "https://downloads.sourceforge.net/project/mrbayes/mrbayes/3.2.5/mrbayes-3.2.5.tar.gz"
  sha256 "31309af428fb52208af4663ddad38b6ff120fe8e7cedd75cf50818f59eb49000"

  head "https://mrbayes.svn.sourceforge.net/svnroot/mrbayes/trunk/"

  bottle do
    cellar :any
    sha256 "72e4f76b89c9ba2af17053982eb70ceb4be5abc08b51fc064cba29afb62eb295" => :yosemite
    sha256 "93d5d55f6eed5e6bbeb9a1a012b33ec6901b55fb5f5187d44b4ba66070494446" => :mavericks
    sha256 "8056f58206496186e970b1f91508fd6741dc6f8087f6ad9db50a285f333c326a" => :mountain_lion
    sha256 "5e4a37b82821208758b0de2d71b30c6b21900939c899997c19427c89dd9d7310" => :x86_64_linux
  end

  option "with-beagle", "Build with BEAGLE library support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on mpi: [:cc, :optional]
  depends_on "beagle" => :optional

  fails_with :llvm do
    build 2336
    cause "build hangs at calling `as`: http://sourceforge.net/tracker/index.php?func=detail&aid=3426528&group_id=129302&atid=714418"
  end

  def install
    args = ["--disable-debug", "--prefix=#{prefix}"]
    args << "--with-beagle=" + ((build.with? "beagle") ? "#{Formula["beagle"].opt_prefix}" : "no")
    args << "--enable-mpi="  + ((build.with? "mpi") ? "yes" : "no")

    cd "src" do
      system "autoconf"
      system "./configure", *args
      system "make"
      bin.install "mb"
    end

    # Doc and examples are not included in the svn
    pkgshare.install ["documentation", "examples"] unless build.head?
  end

  def caveats
    unless build.head?
      <<-EOS.undent
        The documentation and examples are installed to
            #{HOMEBREW_PREFIX}/share/mrbayes
      EOS
    end
  end

  test do
    pipe_output(bin/"mb", "Execute #{pkgshare}/examples/finch.nex")
  end
end
