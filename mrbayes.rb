class Mrbayes < Formula
  homepage "http://mrbayes.sourceforge.net/"
  #tag "bioinformatics"
  #doi "10.1093/bioinformatics/btg180"

  url "https://downloads.sourceforge.net/project/mrbayes/mrbayes/3.2.3/mrbayes-3.2.3.tar.gz"
  sha1 "8492ce3b33369b10e89553f56a9a94724772ae2d"

  head "https://mrbayes.svn.sourceforge.net/svnroot/mrbayes/trunk/"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "6b0d27db5b1f239bfce612bb9747af35227f9812" => :yosemite
    sha1 "50aa531fa4ab7328d547280786150f5a39664260" => :mavericks
    sha1 "993066f9ca815ae3680d5a142772500d5998f4b3" => :mountain_lion
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
    system "echo version |#{bin}/mb"
  end
end
