require 'formula'

class Mrbayes < Formula
  homepage 'http://mrbayes.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/mrbayes/mrbayes/3.2.2/mrbayes-3.2.2.tar.gz'
  sha1 '6f469f595a3dbd2f8394cb29bc70ca1773338ac8'

  head 'https://mrbayes.svn.sourceforge.net/svnroot/mrbayes/trunk/'

  option 'with-beagle', 'Build with BEAGLE library support'

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on :mpi => [:cc, :optional]
  depends_on 'beagle' => :optional

  fails_with :llvm do
    build 2336
    cause "build hangs at calling `as`: http://sourceforge.net/tracker/index.php?func=detail&aid=3426528&group_id=129302&atid=714418"
  end

  def install
    args = ["--disable-debug", "--prefix=#{prefix}"]

    if build.with? 'beagle'
      args << "--with-beagle=#{Formula["beagle"].opt_prefix}"
    else
      args << "--with-beagle=no"
    end

    if build.with? "mpi"
      # Open-mpi builds only with llvm-gcc due to a bug (see open-mpi formula)
      # therefore open-mpi attempts to run llvm-gcc instead of clang.
      # But MrBayes hangs with llvm-gcc!
      # https://sourceforge.net/tracker/index.php?func=detail&aid=3426528&group_id=129302&atid=714418
      ENV['OMPI_CC'] = ENV.cc
      args << "--enable-mpi=yes"
    end

    cd 'src' do
      system "autoconf"
      system "./configure", *args
      system "make"
      bin.install "mb"
    end

    # Doc and examples are not included in the svn
    (share/'mrbayes').install ['documentation', 'examples'] unless build.head?
  end

  def caveats
    unless build.head?
      <<-EOS.undent
        The documentation and examples are installed to
            #{HOMEBREW_PREFIX}/share/mrbayes
      EOS
    end
  end

  def test
    system "echo 'version' | #{bin}/mb"
  end
end
