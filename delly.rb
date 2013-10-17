require 'formula'

class Delly < Formula
  homepage 'http://www.embl.de/~rausch/delly.html'
  url 'http://www.embl.de/~rausch/delly_source_v0.0.11.tar.gz'
  sha1 'd0e1cd95a0d526e308c5aff88c19212e558d9a1f'

  depends_on 'bamtools'
  depends_on 'boost'

  def patches
    # Allows Makefile to find boost and bamtools within Homebrew hierarchy
    DATA
  end

  def install
    cd 'pemgr' do
      inreplace 'Makefile', 'LDFLAGS += --static', ''
      inreplace 'Makefile', /(-lboost[^ ]*)/, '\1-mt' if OS.mac?
      system 'make', "CXX=#{ENV.cxx}"
      bin.install %w{delly/delly duppy/duppy invy/invy jumpy/jumpy}
    end
    doc.install 'README'
  end

  test do
    system 'delly 2>&1 |grep -q delly'
  end
end
__END__
--- a/pemgr/Makefile	2013-06-06 16:19:51.000000000 -0400
+++ b/pemgr/Makefile	2013-10-17 06:29:19.132265246 -0400
@@ -1,8 +1,8 @@
-BOOST=/g/solexa/bin/software/boost_1_53_0
-BAMTOOLS=/g/solexa/bin/software/bamtools/
+BOOST=HOMEBREW_PREFIX
+BAMTOOLS=HOMEBREW_PREFIX
 
 CXX=g++
-CXXFLAGS += -isystem ${BOOST}/include -isystem ${BAMTOOLS}/include -I../torali
+CXXFLAGS += -isystem ${BOOST}/include -isystem ${BAMTOOLS}/include/bamtools -I../torali
 CXXFLAGS += -O9 -pedantic -W -Wall
 
 ### Valgrind
