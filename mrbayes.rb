class Mrbayes < Formula
  homepage "http://mrbayes.sourceforge.net/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg180"

  url "https://downloads.sourceforge.net/project/mrbayes/mrbayes/3.2.5/mrbayes-3.2.5.tar.gz"
  sha256 "a9f3f308ead95cfee50a4953ff19e60c5edf2c6c8d4809bec86d5625cdefdb87"

  head "https://mrbayes.svn.sourceforge.net/svnroot/mrbayes/trunk/"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "d8753bb5ad04d7f5481c5744af4ff78235751e8a936040d13e666d870b2af641" => :yosemite
    sha256 "39f07a0d316efb2af118d66961607b56457d7a140fad57a0cd26a2c3382fd4d6" => :mavericks
    sha256 "acd69ab3f139618ab5404e85cbebc3b11bdf413edfc930e13f7d79d1ff1492cc" => :mountain_lion
  end

  option "with-beagle", "Build with BEAGLE library support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :mpi => [:cc, :optional]
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
    (share/"mrbayes").install ["documentation", "examples"] unless build.head?
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
    pipe_output(bin/"mb", "Execute #{share}/mrbayes/examples/finch.nex")
  end
end
