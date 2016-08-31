class EaUtils < Formula
  desc "Tools for processing biological sequencing data"
  homepage "https://code.google.com/p/ea-utils/"
  url "https://drive.google.com/uc?export=download&id=0B7KhouP0YeRAc2xackxzRnFrUEU"
  version "1.1.2-806"
  sha256 "31f059ac2d6282d8e0e25047fc6aa5448f8c41de6067eaf6b456054cd53c782c"
  revision 1

  bottle do
    cellar :any
    sha256 "bb3116f69666889f74899b96462e265d88799f97a83c1fa31e7cf5dbc7ded22f" => :el_capitan
    sha256 "f11288348e64a622a40f194565fe1227725e91c85cffe0d6bf3ae72c574ea11a" => :yosemite
    sha256 "58289b2d340c6e6d26e4c1a79f9144ef21d56ed4d0244e8ef89a5b6e9d562afa" => :mavericks
  end

  depends_on "gsl"

  # Patch from upstream issue: https://code.google.com/p/sparsehash/issues/detail?id=99
  # https://github.com/sparsehash/sparsehash/commit/6f37a2b8bd3dff54874249799dca4c2458596c1d
  # https://github.com/sparsehash/sparsehash/commit/7f6351fb06241b96fdb39ae3aff53c2acb1cd7a4
  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}"
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

diff --git a/sparsehash-2.0.2/src/hashtable_test.cc b/sparsehash-2.0.2/src/hashtable_test.cc
index 21c60a7..ede7c65 100644
--- a/sparsehash-2.0.2/src/hashtable_test.cc
+++ b/sparsehash-2.0.2/src/hashtable_test.cc
@@ -901,7 +901,7 @@ TYPED_TEST(HashtableAllTest, Swap) {
 #ifdef _MSC_VER
   other_ht.swap(this->ht_);
 #else
-  swap(this->ht_, other_ht);
+  std::swap(this->ht_, other_ht);
 #endif

   EXPECT_EQ(this->UniqueKey(1), this->ht_.deleted_key());
