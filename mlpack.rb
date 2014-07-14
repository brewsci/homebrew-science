require "formula"

class Mlpack < Formula
  homepage "http://www.mlpack.org"
  url "http://www.mlpack.org/files/mlpack-1.0.8.tar.gz"
  sha1 "f7fce9d37964fb6ede017d29799155f0a08a3e0e"

  option :cxx11
  cxx11dep = (build.cxx11?) ? ['c++11'] : []

  depends_on "cmake" => :build
  depends_on "libxml2"
  depends_on "armadillo" => cxx11dep
  depends_on "boost" => cxx11dep
  depends_on "txt2man" => :optional

  option "with-debug", "Compile with debug options"
  option "with-profile", "Compile with profile options"
  option "without-check", "Disable build-time tests (not recommended)"

  # fixes test error in an edge case (may not needed in future version)
  # See https://mailman.cc.gatech.edu/pipermail/mlpack/2014-March/000294.html
  patch :DATA

  def install
    ENV.cxx11 if build.cxx11?
    cmake_args = std_cmake_args
    cmake_args << "-DDEBUG=" + ((build.with? "debug") ? "ON" : "OFF")
    cmake_args << "-DPROFILE=" + ((build.with? "profile") ? "ON" : "OFF")
    cmake_args << "-DBOOST_ROOT=#{Formula['boost'].opt_prefix}"
    cmake_args << "-DARMADILLO_INCLUDE_DIR=#{Formula['armadillo'].opt_prefix}/include"
    cmake_args << "-DARMADILLO_LIBRARY=#{Formula['armadillo'].opt_prefix}/lib/libarmadillo.dylib"

    mkdir 'build' do
      system "cmake", "..", *cmake_args
      system "make", "test" if build.with? "check"
      system "make", "install"
    end
  end
end

__END__
diff -rupN mlpack-1.0.8/src/mlpack/methods/nmf/mult_div_update_rules.hpp r16349/src/mlpack/methods/nmf/mult_div_update_rules.hpp
--- mlpack-1.0.8/src/mlpack/methods/nmf/mult_div_update_rules.hpp	2014-01-07 12:34:08.000000000 +0800
+++ r16349/src/mlpack/methods/nmf/mult_div_update_rules.hpp	2014-03-09 21:16:31.000000000 +0800
@@ -75,10 +75,18 @@ class WMultiplicativeDivergenceRule
         t2.set_size(H.n_cols);
         for (size_t k = 0; k < t2.n_elem; ++k)
         {
+          // This may produce NaNs if V(i, k) = 0.
+          // Technically the math in the paper does not define what to do in
+          // this case, but considering the basic intent of the update rules,
+          // we'll make this modification and take t2(k) = 0.0.
           t2(k) = H(j, k) * V(i, k) / t1(i, k);
+          if (t2(k) != t2(k))
+            t2(k) = 0.0;
         }
 
-        W(i, j) = W(i, j) * sum(t2) / sum(H.row(j));
+        // Only update if the sum is not going to be 0, so as to prevent a
+        // divide by zero.  If sum(H.row(j)) is 0, then t2 should be 0 too.
+        W(i, j) *= sum(t2) / sum(H.row(j));
       }
     }
   }
@@ -126,10 +134,18 @@ class HMultiplicativeDivergenceRule
         t2.set_size(W.n_rows);
         for (size_t k = 0; k < t2.n_elem; ++k)
         {
+          // This may produce NaNs if V(i, k) = 0.
+          // Technically the math in the paper does not define what to do in
+          // this case, but considering the basic intent of the update rules,
+          // we'll make this modification and take t2(k) = 0.0.
           t2(k) = W(k, i) * V(k, j) / t1(k, j);
+          if (t2(k) != t2(k))
+            t2(k) = 0.0;
         }
 
-        H(i,j) = H(i,j) * sum(t2) / sum(W.col(i));
+        // Only update if the sum is not going to be 0, so as to prevent a
+        // divide by zero.  If sum(W.col(j)) is 0, then t2 should be 0 too.
+        H(i, j) *= sum(t2) / sum(W.col(i));
       }
     }
   }
