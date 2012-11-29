require 'formula'

class Mrbayes < Formula
  homepage 'http://mrbayes.sourceforge.net/'
  url 'http://sourceforge.net/projects/mrbayes/files/mrbayes/3.2.1/mrbayes-3.2.1.tar.gz'
  sha1 '8fcb2b7055bde57b33120e6d17ce1a12e399a9a8'
  head 'https://mrbayes.svn.sourceforge.net/svnroot/mrbayes/trunk/', :using => :svn

  option 'with-beagle', 'Build with BEAGLE library support'
  option 'with-mpi', 'Build with MPI parallel support'
  option 'no-fast-math', 'Build with default Homebrew optimizations'

  depends_on :autoconf => :build
  depends_on MPIDependency.new(:cc) if build.include? 'with-mpi'

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-beagle=no" unless build.include? 'with-beagle'
    args << "--enable-mpi=yes" if build.include? 'with-mpi'
    ENV.delete 'CFLAGS' unless build.include? 'no-fast-math'

    cd 'src' do
      system "autoconf"
      system "./configure", *args
      system "make"
      bin.install "mb"
    end
  end

  def test
    system "echo 'version' | #{bin}/mb"
  end
end
