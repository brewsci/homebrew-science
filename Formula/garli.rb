class Garli < Formula
  desc "genetic algorithm for rapid likelihood inference of phylogenies"
  homepage "https://code.google.com/p/garli/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/garli/garli-2.01.tar.gz"
  sha256 "e7fd4c115f9112fd9a019dcb6314e3a9d989f56daa0f833a28dc8249e50988ef"
  revision 2
  # tag "bioinformatics"

  bottle :disable, "needs to be rebuilt with latest open-mpi"

  option "with-brewed-ncl", "Use Homebrew's NCL instead of building a separate copy"
  depends_on "ncl" if build.with? "brewed-ncl"
  depends_on :mpi => :recommended

  # Fix template instantiation errors by making GCC infer types rather than
  # explicitly specifying the types. Patch emailed to upstream 12-Jun-2016.
  patch :DATA

  fails_with :clang do
    build 703
    cause "error: invalid operands to binary expression ('const ReconNode' and 'const ReconNode')"
  end

  def install
    # Garli needs to link to NCL, which Homebrew provides. However Garli
    # needs NCL to be built with the same compiler and very specific build
    # options. Since Garli *must* be built with GCC (see `fails_with` block)
    # and brewed NCL is built with Clang, we build our own copy in `libexec`.
    #
    # Example visibility issues with mismatched Garli/NCL builds:
    #
    # Undefined symbols for architecture x86_64:
    #   "non-virtual thunk to NxsCharactersBlock::GetMaxIndex() const", referenced from:
    #         vtable for NxsCharactersBlock in adaptation.o
    #         vtable for NxsCharactersBlock in condlike.o
    #         ...
    #
    # ld: symbol(s) not found for architecture x86_64
    # collect2: error: ld returned 1 exit status

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args.push "--enable-mpi" if build.with? "mpi"

    if build.with? "brewed-ncl"
      args.push "--with-ncl=#{Formula["ncl"].opt_prefix}"
    else
      args.push "--with-ncl=#{libexec}/ncl"
      system "tar", "xf", "ncl-2.1.18.tar.gz"
      cd "ncl-2.1.18" do
        system "./configure", "--prefix=#{libexec}/ncl", "--disable-shared", "--enable-static", "CXXFLAGS=-DNCL_CONST_FUNCS"
        system "make", "install"
      end
    end

    system "./configure", *args
    system "make", "install"

    pkgshare.install "doc"
    pkgshare.install "example"
  end

  def caveats; <<-EOS.undent
    The manual and examples have been installed to:

      #{opt_pkgshare}/doc
      #{opt_pkgshare}/example
    EOS
  end

  test do
    system "#{bin}/Garli", "--version"

    (testpath/"aln.phy").write <<-EOS.undent
       10 60
      Cow       ATGGCATATCCCATACAACTAGGATTCCAAGATGCAACATCACCAATCATAGAAGAACTA
      Carp      ATGGCACACCCAACGCAACTAGGTTTCAAGGACGCGGCCATACCCGTTATAGAGGAACTT
      Chicken   ATGGCCAACCACTCCCAACTAGGCTTTCAAGACGCCTCATCCCCCATCATAGAAGAGCTC
      Human     ATGGCACATGCAGCGCAAGTAGGTCTACAAGACGCTACTTCCCCTATCATAGAAGAGCTT
      Loach     ATGGCACATCCCACACAATTAGGATTCCAAGACGCGGCCTCACCCGTAATAGAAGAACTT
      Mouse     ATGGCCTACCCATTCCAACTTGGTCTACAAGACGCCACATCCCCTATTATAGAAGAGCTA
      Rat       ATGGCTTACCCATTTCAACTTGGCTTACAAGACGCTACATCACCTATCATAGAAGAACTT
      Seal      ATGGCATACCCCCTACAAATAGGCCTACAAGATGCAACCTCTCCCATTATAGAGGAGTTA
      Whale     ATGGCATATCCATTCCAACTAGGTTTCCAAGATGCAGCATCACCCATCATAGAAGAGCTC
      Frog      ATGGCACACCCATCACAATTAGGTTTTCAAGACGCAGCCTCTCCAATTATAGAAGAATTA
      ;
      end;
    EOS

    cp pkgshare/"example"/"basic"/"garli.conf.nuc.test", testpath/"garli.conf"
    inreplace "garli.conf", "zakonEtAl2006.11tax.nex", "aln.phy"

    if build.with? "mpi"
      system "mpirun", "-np", "2", "#{bin}/Garli", "-2"
    else
      system "#{bin}/Garli", "-1"
    end
  end
end
__END__
diff --git a/src/configreader.cpp b/src/configreader.cpp
index 597d8c0..5257dba 100644
--- a/src/configreader.cpp
+++ b/src/configreader.cpp
@@ -21,6 +21,7 @@
 #include <iostream>
 #include <limits.h>
 #include <math.h>
+#include <utility>

 using namespace std;

@@ -635,6 +636,6 @@ void ConfigReader::MakeAllSection(){
	map<std::string, std::string> ops = sections["general"];
	ops.insert(sections["master"].begin(), sections["master"].end());
	string name="all";
-	sections.insert(make_pair<std::string, Options>(name, ops));
+	sections.insert(make_pair(name, ops));
	}

diff --git a/src/tree.cpp b/src/tree.cpp
index c9d3017..29c2406 100644
--- a/src/tree.cpp
+++ b/src/tree.cpp
@@ -8365,7 +8365,7 @@ pair<FLOAT_TYPE, FLOAT_TYPE> Tree::OptimizeSingleSiteTreeScale(FLOAT_TYPE optPre
 #endif

	if(FloatingPointEquals(lnL, ZERO_POINT_ZERO, max(1.0e-8, GARLI_FP_EPS * 2.0))){
-		return make_pair<FLOAT_TYPE, FLOAT_TYPE>(-ONE_POINT_ZERO, ZERO_POINT_ZERO);
+		return make_pair(-ONE_POINT_ZERO, ZERO_POINT_ZERO);
		}

	int pass=1;
@@ -8396,7 +8396,7 @@ pair<FLOAT_TYPE, FLOAT_TYPE> Tree::OptimizeSingleSiteTreeScale(FLOAT_TYPE optPre
			Score();
			FLOAT_TYPE s = lnL/siteCount;
			ScaleWholeTree(1.0/1.1);
-			if(fabs(prev - s) < max(1.0e-8, GARLI_FP_EPS * 2.0)) return make_pair<FLOAT_TYPE, FLOAT_TYPE>(-ONE_POINT_ZERO, prev);
+			if(fabs(prev - s) < max(1.0e-8, GARLI_FP_EPS * 2.0)) return make_pair(-ONE_POINT_ZERO, prev);
			}

		scale=ONE_POINT_ZERO + incr;
@@ -8416,7 +8416,7 @@ pair<FLOAT_TYPE, FLOAT_TYPE> Tree::OptimizeSingleSiteTreeScale(FLOAT_TYPE optPre
		if(estImprove < optPrecision && d2 < ZERO_POINT_ZERO){
			ScaleWholeTree(ONE_POINT_ZERO/effectiveScale);
			//cout << pass << endl;
-			return make_pair<FLOAT_TYPE, FLOAT_TYPE>(effectiveScale, prev);
+			return make_pair(effectiveScale, prev);
			}

		if(d2 < ZERO_POINT_ZERO){
@@ -8445,13 +8445,13 @@ pair<FLOAT_TYPE, FLOAT_TYPE> Tree::OptimizeSingleSiteTreeScale(FLOAT_TYPE optPre

		scale=t;
		effectiveScale *= scale;
-		if(effectiveScale > 100.0) return make_pair<FLOAT_TYPE, FLOAT_TYPE>(100.0, prev);
+		if(effectiveScale > 100.0) return make_pair(100.0, prev);
		ScaleWholeTree(scale);
		if(effectiveScale < 1e-4){
			//The rate is essentially zero.  Invariant sites should be getting caught
			//before even calling this func, so this probably won't be visited
			ScaleWholeTree(1.0/effectiveScale);
-			return make_pair<FLOAT_TYPE, FLOAT_TYPE>(effectiveScale, prev);
+			return make_pair(effectiveScale, prev);
			}

		Score();
