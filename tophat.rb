require 'formula'

class Tophat < Formula
  homepage 'http://tophat.cbcb.umd.edu/'
  url 'http://tophat.cbcb.umd.edu/downloads/tophat-2.0.10.tar.gz'
  sha1 '1c9d273d929d9145a75c5468b31c2e6b56e59654'

  depends_on 'samtools'
  depends_on 'boost'
  # bowtie2 is required to execute tophat
  depends_on 'bowtie2' => :recommended

  # 1. Fix namespace issue in segment_juncs.cpp
  # 2. Fix "Variable length arrays using non-POD element types" error
  # in tophat_reports.cpp
  # Reported upstream:
  # https://groups.google.com/forum/#!topic/tuxedo-tools-users/hOOVgXwB0NQ
  def patches
     DATA
  end

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
    system *%w[tophat --version]

    # Run a simple test as described in
    # http://tophat.cbcb.umd.edu/tutorial.shtml#ref
    curl *%w[-O http://tophat.cbcb.umd.edu/downloads/test_data.tar.gz]
    system *%w[tar xzf test_data.tar.gz]
    cd 'test_data' do
      system *%w[tophat -r 20 test_ref reads_1.fq reads_2.fq]
    end
  end
end

__END__
diff --git a/src/segment_juncs.cpp b/src/segment_juncs.cpp
index 80fb3b7..bc55db7 100644
--- a/src/segment_juncs.cpp
+++ b/src/segment_juncs.cpp
@@ -47,7 +47,6 @@

 using namespace seqan;
 using namespace std;
-using namespace __gnu_cxx;

 // daehwan //geo
 //#define B_DEBUG 1
diff --git a/src/tophat_reports.cpp b/src/tophat_reports.cpp
index 9d0a927..a403dbe 100644
--- a/src/tophat_reports.cpp
+++ b/src/tophat_reports.cpp
@@ -2784,10 +2784,10 @@ for (; deletion_iter != deletions.end(); ++deletion_iter)
 			fprintf(stderr, "Warning: %lu small overhang junctions!\n", (long unsigned int)small_overhangs);
 	 */

-	JunctionSet vfinal_junctions[num_threads];
-	InsertionSet vfinal_insertions[num_threads];
-	DeletionSet vfinal_deletions[num_threads];
-	FusionSet vfinal_fusions[num_threads];
+	JunctionSet * vfinal_junctions = new JunctionSet[num_threads];
+	InsertionSet * vfinal_insertions = new InsertionSet[num_threads];
+	DeletionSet * vfinal_deletions = new DeletionSet[num_threads];
+	FusionSet * vfinal_fusions = new FusionSet[num_threads];

 	vector<SAlignStats> alnStats(num_threads);

@@ -2931,6 +2931,11 @@ for (; deletion_iter != deletions.end(); ++deletion_iter)
 	}

 	fprintf(stderr, "Found %lu junctions from happy spliced reads\n", (long unsigned int)final_junctions.size());
+
+	delete[] vfinal_junctions;
+	delete[] vfinal_insertions;
+	delete[] vfinal_deletions;
+	delete[] vfinal_fusions;
 }

 void print_usage()
