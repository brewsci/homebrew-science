class Tophat < Formula
  desc "Spliced read mapper for RNA-Seq"
  homepage "https://ccb.jhu.edu/software/tophat"
  url "https://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.tar.gz"
  sha256 "37840b96f3219630082b15642c47f5ef95d14f6ee99c06a369b08b3d05684da5"
  revision 7
  # doi "10.1093/bioinformatics/btp120"
  # tag "bioinformatics"

  bottle :disable, "needs to be rebuilt with latest boost"

  depends_on "boost"
  depends_on "bowtie2"
  depends_on "bowtie" => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  patch :p0, :DATA

  resource "test" do
    url "https://ccb.jhu.edu/software/tophat/downloads/test_data.tar.gz"
    sha256 "18840bd020dd23f4fe298d935c82f4b8ef7974de62ff755c21d7f88dc40054e1"
  end

  def install
    ENV.deparallelize
    ENV.append "LIBS", "-lboost_system-mt -lboost_thread-mt"

    resource("test").stage { (share/"test_data").install Dir["*"] }

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # clean up Python libraries from bin
    (libexec/"python").install bin/"intervaltree", bin/"sortedcontainers"
    (libexec/"bin").install bin/"tophat-fusion-post"
    (bin/"tophat-fusion-post").write_env_script libexec/"bin/tophat-fusion-post",
      :PYTHONPATH => libexec/"python"
  end

  test do
    system bin/"tophat", "-r", "20",
      share/"test_data/test_ref",
      share/"test_data/reads_1.fq", share/"test_data/reads_2.fq"
    assert_match "71.0%", File.read("tophat_out/align_summary.txt")
    system bin/"tophat-fusion-post", "--version"
  end
end
__END__
--- src/samtools-0.1.18/ksort.h.orig	2014-10-02 22:42:08.000000000 -0700
+++ src/samtools-0.1.18/ksort.h	2014-10-02 22:43:14.000000000 -0700
@@ -141,7 +141,7 @@
 			tmp = *l; *l = l[i]; l[i] = tmp; ks_heapadjust_##name(0, i, l); \
 		}																\
 	}																	\
-	inline void __ks_insertsort_##name(type_t *s, type_t *t)			\
+	static inline void __ks_insertsort_##name(type_t *s, type_t *t)			\
 	{																	\
 		type_t *i, *j, swap_tmp;										\
 		for (i = s + 1; i < t; ++i)										\
--- src/tophat.py       2016-02-15 11:30:16.619093000 -0800
+++ src/tophat.py       2016-07-17 09:40:08.041311408 -0700
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python2.7

 # encoding: utf-8
 """
--- src/tophat2.sh      2016-02-23 18:51:33.274718000 -0800
+++ src/tophat2.sh        2016-07-17 09:40:56.017800465 -0700
@@ -1,6 +1,6 @@
 #!/usr/bin/env bash
 pbin=""
-fl=$(readlink $0)
+fl=$(readlink -f $0)
 if [[ -z "$fl" ]]; then
    pbin=$(dirname $0)
  else
--- src/bed_to_juncs        2016-02-14 10:21:17.133079000 -0800
+++ src/bed_to_juncs  2016-07-17 09:53:12.097361445 -0700
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python2.7
 # encoding: utf-8
 """
 bed_to_juncs.py
--- src/contig_to_chr_coords        2016-02-14 10:21:17.199079000 -0800
+++ src/contig_to_chr_coords  2016-07-17 09:53:12.105361528 -0700
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python2.7
 # encoding: utf-8
 """
 contig_to_chr_coords.py
--- src/sra_to_solid        2016-02-14 10:21:17.802079000 -0800
+++ src/sra_to_solid  2016-07-17 09:53:12.109361569 -0700
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python2.7

 """
 sra_to_solid.py
--- src/tophat-fusion-post  2016-02-23 13:20:44.317710000 -0800
+++ src/tophat-fusion-post    2016-07-17 09:53:12.113361611 -0700
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python2.7


 """
