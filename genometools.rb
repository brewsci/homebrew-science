require "formula"

class Genometools < Formula
  homepage "http://genometools.org/"
  url "http://genometools.org/pub/genometools-1.5.1.tar.gz"
  sha1 "c2ed4b655175f28b87270f93f154762d3541f177"

  option :universal
  option 'with-check', "Run tests which require approximately one hour to run"
  option 'without-pangocairo', 'Build without Pango/Cairo (disables AnnotationSketch tool)'
  option 'with-hmmer', 'Build with HMMER (to enable protein domain search functionality in the ltrdigest tool)'

  depends_on 'cairo' unless build.include? 'without-pangocairo'
  depends_on 'pango' unless build.include? 'without-pangocairo'

  def patches
    # Allow use of /usr/local/share for gtdata directory
    # Currently it must be in /usr/share or /usr/local/bin
    # Patch sumitted to upstream source (and accepted, not yet released)
    # https://github.com/genometools/genometools/pull/234
    DATA
  end

  def install
    args = ["prefix=#{prefix}"]
    args << 'cairo=no' if build.include? 'without-pangocairo'
    args << 'with-hmmer=yes' if build.with? 'hmmer'
    args << 'universal=yes' if build.universal?
    args << '64bit=yes' if MacOS.prefer_64_bit?

    system 'make', *args
    system 'make', 'test', *args if build.with? 'check'
    system 'make', 'install', *args

    (share/'genometools').install bin/'gtdata'
  end

  test do
    system "#{bin}/gt -test"
  end
end

__END__
diff --git a/src/core/gtdatapath.c b/src/core/gtdatapath.c
index c1f7bb9..a43a423 100644
--- a/src/core/gtdatapath.c
+++ b/src/core/gtdatapath.c
@@ -23,6 +23,7 @@
 #define GTDATADIR "/gtdata"
 #define UPDIR     "/.."
 static const char* GTDATA_DEFAULT_PATHS[]={ "/usr/share/genometools" GTDATADIR,
+                                            "/usr/local/share/genometools" GTDATADIR,
                                             NULL };

 GtStr* gt_get_gtdata_path(const char *prog, GtError *err)
