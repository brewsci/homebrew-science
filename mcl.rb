require "formula"

class Mcl < Formula
  homepage "http://micans.org/mcl"
  url "http://micans.org/mcl/src/mcl-14-136.tar.gz"
  version "14-136"
  sha1 "7a0973cbd884b20f554bcb20215d7d280a0cb569"

  # Fixes a problem in upstream where cpu_set_t is used without guarding it
  # in an #ifdef _GNU_SOURCE block. Upstream has been notified; the patch can
  # safely be removed when it is merged.
  patch :DATA

  def install
    bin.mkpath
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-blast"
    system "make install"
  end
end

__END__
diff --git a/src/impala/matrix.c b/src/impala/matrix.c
index 38f057c..087926f 100644
--- a/src/impala/matrix.c
+++ b/src/impala/matrix.c
@@ -2072,7 +2072,9 @@ mcxstatus mclxVectorDispatchGroup
    ;  struct generic_arg* garg = mcxAlloc(n_thread * sizeof garg[0], EXIT_ON_FAIL)
    ;  pthread_attr_t  t_attr
    ;  dim thread_id = 0, t_spun = 0
+#ifdef _GNU_SOURCE
    ;  cpu_set_t cpuset[512] = { 0 }
+#endif
 
    ;  if (n_group == 0 || group_id >= n_group)
       {  mcxErr("mclxVectorDispatchGroup PBD", "wrong parameters")

