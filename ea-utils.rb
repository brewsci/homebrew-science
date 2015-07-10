class EaUtils < Formula
  desc "Tools for processing biological sequencing data"
  homepage "https://code.google.com/p/ea-utils/"
  url "https://drive.google.com/uc?export=download&id=0B7KhouP0YeRAc2xackxzRnFrUEU"
  version "1.1.2-806"
  sha256 "31f059ac2d6282d8e0e25047fc6aa5448f8c41de6067eaf6b456054cd53c782c"
  depends_on "gsl"

  # Patch from upstream issue: https://code.google.com/p/sparsehash/issues/detail?id=99
  patch :DATA

  def install
    system "make",  "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.sam").write("GEN-SEQ-ANA_0001:1:1:17434:14109#0/1\t0\tPCRPRIMER1\t5\t255\t33M\t*\t0\t0\tATACGGCGACCACCGAGATCTACACTCTTTCCC\t?<??>>BB>>A5AAA;;9:B<A?:AAA<B<AAA\tXA:i:0  MD:Z:33 NM:i:0\n")
    system "#{bin}/sam-stats", "test.sam"
  end
end
__END__
diff --git a/sparsehash-2.0.2/src/sparsehash/internal/sparsehashtable.h b/sparsehash-2.0.2/src/sparsehash/internal/sparsehashtable.h
index 7ee1391..f54ea51 100644
--- a/sparsehash-2.0.2/src/sparsehash/internal/sparsehashtable.h
+++ b/sparsehash-2.0.2/src/sparsehash/internal/sparsehashtable.h
@@ -165,7 +165,7 @@ struct sparse_hashtable_iterator {
  public:
   typedef sparse_hashtable_iterator<V,K,HF,ExK,SetK,EqK,A>       iterator;
   typedef sparse_hashtable_const_iterator<V,K,HF,ExK,SetK,EqK,A> const_iterator;
-  typedef typename sparsetable<V,DEFAULT_GROUP_SIZE,A>::nonempty_iterator
+  typedef typename sparsetable<V,DEFAULT_GROUP_SIZE,value_alloc_type>::nonempty_iterator
       st_iterator;

   typedef std::forward_iterator_tag iterator_category;  // very little defined!
@@ -217,7 +217,7 @@ struct sparse_hashtable_const_iterator {
  public:
   typedef sparse_hashtable_iterator<V,K,HF,ExK,SetK,EqK,A>       iterator;
   typedef sparse_hashtable_const_iterator<V,K,HF,ExK,SetK,EqK,A> const_iterator;
-  typedef typename sparsetable<V,DEFAULT_GROUP_SIZE,A>::const_nonempty_iterator
+  typedef typename sparsetable<V,DEFAULT_GROUP_SIZE,value_alloc_type>::const_nonempty_iterator
       st_iterator;

   typedef std::forward_iterator_tag iterator_category;  // very little defined!
@@ -271,7 +271,7 @@ struct sparse_hashtable_destructive_iterator {

  public:
   typedef sparse_hashtable_destructive_iterator<V,K,HF,ExK,SetK,EqK,A> iterator;
-  typedef typename sparsetable<V,DEFAULT_GROUP_SIZE,A>::destructive_iterator
+  typedef typename sparsetable<V,DEFAULT_GROUP_SIZE,value_alloc_type>::destructive_iterator
       st_iterator;

   typedef std::forward_iterator_tag iterator_category;  // very little defined!
