require 'formula'

class Cufflinks < Formula
  homepage 'http://cufflinks.cbcb.umd.edu/'
  url 'http://cufflinks.cbcb.umd.edu/downloads/cufflinks-2.0.2.tar.gz'
  sha1 '91954b4945c49ca133b39bffadf51bdf9ec2ff26'

  depends_on 'boost'    => :build
  depends_on 'samtools' => :build
  depends_on 'eigen'    => :build

  fails_with :clang do
    build 425
  end

  def patches
    # Fix a build error: ‘aNode’ was not declared in this scope
    DATA
  end

  def install
    ENV['EIGEN_CPPFLAGS'] = '-I'+Formula.factory('eigen').include/'eigen3'
    ENV.append 'LIBS', '-lboost_system-mt -lboost_thread-mt'
    cd 'src' do
      # Fixes 120 files redefining `foreach` that break building with boost
      # See http://seqanswers.com/forums/showthread.php?t=16637
      `for x in *.cpp *.h; do sed 's/foreach/for_each/' $x > x; mv x $x; done`
      inreplace 'common.h', 'for_each.hpp', 'foreach.hpp'
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
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

__END__
--- a/src/lemon/bits/base_extender.h	2014-06-27 11:36:54.364248892 -0700
+++ b/src/lemon/bits/base_extender.h	2013-06-27 11:36:58.268248818 -0700
@@ -359,10 +359,10 @@
 		}
 		
 		Node source(const UEdge& edge) const {
-			return aNode(edge);
+			return this->aNode(edge);
 		}
 		Node target(const UEdge& edge) const {
-			return bNode(edge);
+			return this->bNode(edge);
 		}
 		
 		void firstInc(UEdge& edge, bool& dir, const Node& node) const {
