require "formula"

class Cufflinks < Formula
  homepage "http://cufflinks.cbcb.umd.edu/"
  url "http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.tar.gz"
  sha1 "2b1b3a8f12cd2821ffc74ffbdd55cb329f37cbbb"

  depends_on "homebrew/versions/boost149"    => :build
  depends_on "samtools-0.1" => :build
  depends_on "eigen"    => :build

  def install
    ENV['EIGEN_CPPFLAGS'] = "-I#{Formula["eigen"].opt_include}/eigen3"
    ENV.append 'LIBS', '-lboost_system-mt -lboost_thread-mt'
    cd 'src' do
      # Fixes 120 files redefining `foreach` that break building with boost
      # See http://seqanswers.com/forums/showthread.php?t=16637
      `for x in *.cpp *.h; do sed 's/foreach/for_each/' $x > x; mv x $x; done`
      inreplace 'common.h', 'for_each.hpp', 'foreach.hpp'
    end
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system 'make'
    ENV.j1
    system 'make install'
  end

  test do
    system "#{bin}/cuffdiff 2>&1 |grep -q cuffdiff"
  end
end
