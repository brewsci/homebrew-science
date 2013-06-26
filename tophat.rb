require 'formula'

class Tophat < Formula
  homepage 'http://tophat.cbcb.umd.edu/'
  url 'http://tophat.cbcb.umd.edu/downloads/tophat-2.0.8b.tar.gz'
  sha1 '0744801fc5216104026259bcdf8b1846bf681d42'

  depends_on 'samtools'
  depends_on 'boost'

  # Variable length arrays using non-POD element types. Initialize with length=1
  # Reported upstream via email to tophat-cufflinks@gmail.com on 28OCT2012
  def patches; DATA; end

  def install
    # This can only build serially, otherwise it errors with no make target.
    ENV.deparallelize

    # Must add this to fix missing boost symbols. Autoconf doesn't include it.
    ENV.append 'LIBS', '-lboost_system-mt -lboost_thread-mt'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/tophat", "--version"
  end
end

__END__
--- a/src/tophat_reports.cpp
+++ b/src/tophat_reports.cpp
@@ -2465,10 +2465,10 @@
     fprintf(stderr, "Warning: %lu small overhang junctions!\n", (long unsigned int)small_overhangs);
   */
 
-  JunctionSet vfinal_junctions[num_threads];
-  InsertionSet vfinal_insertions[num_threads];
-  DeletionSet vfinal_deletions[num_threads];
-  FusionSet vfinal_fusions[num_threads];
+  JunctionSet vfinal_junctions[1];
+  InsertionSet vfinal_insertions[1];
+  DeletionSet vfinal_deletions[1];
+  FusionSet vfinal_fusions[1];
 
   for (int i = 0; i < num_threads; ++i)
     {
