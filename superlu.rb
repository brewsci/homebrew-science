class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_5.1.tar.gz"
  sha256 "307ef10edef4cebc6c7f672cd931ae6682db4c4f5f93a44c78e9544a520e2db1"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1b82baefe35d4d67c4218eac1545fb9c62a98e54c7e396d7d71a657219c7ff6a" => :el_capitan
    sha256 "282d90aac51a642ab0191a57498a72685cbaebd0cc4ab1558f72cb1a29aa6c21" => :yosemite
    sha256 "30f20a55944c3712ddf7522fe9c40f42024849630324c52bfc5d1a1184d862cb" => :mavericks
  end

  deprecated_option "without-check" => "without-test"

  option "without-test", "skip build-time tests (not recommended)"
  option "with-openmp", "Enable OpenMP multithreading"

  depends_on :fortran

  # Accelerate single precision is buggy and causes certain single precision
  # tests to fail.
  depends_on "openblas" => ((OS.mac?) ? :optional : :recommended)
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?

  needs :openmp if build.with? "openmp"

  patch :DATA

  def install
    ENV.deparallelize
    cp "MAKE_INC/make.mac-x", "./make.inc"
    make_args = ["RANLIB=true",
                 "CC=#{ENV.cc}",
                 "CFLAGS=-fPIC #{ENV.cflags}",
                 "FORTRAN=#{ENV.fc}",
                 "FFLAGS=#{ENV.fcflags}",
                 "SuperLUroot=#{buildpath}",
                 "SUPERLULIB=$(SuperLUroot)/lib/libsuperlu.a",
                 "NOOPTS=-fPIC",
                ]

    if build.with? "openblas"
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      blas = (OS.mac?) ? "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort" : "-lblas"
    end
    make_args << "BLASLIB=#{blas}"
    make_args << ("LOADOPTS=" + ((build.with? "openmp") ? "-fopenmp" : ""))

    system "make", "lib", *make_args
    if build.with? "test"
      system "make", "testing", *make_args
      cd "TESTING" do
        system "make", *make_args
        %w[stest dtest ctest ztest].each do |tst|
          ohai `tail -1 #{tst}.out`.chomp
        end
      end
    end

    cd "EXAMPLE" do
      system "make", *make_args
    end

    prefix.install "make.inc"
    File.open(prefix / "make_args.txt", "w") do |f|
      f.puts(make_args.join(" ")) # Record options passed to make.
    end
    lib.install Dir["lib/*"]
    (include / "superlu").install Dir["SRC/*.h"]
    doc.install Dir["Doc/*"]
    (share / "superlu").install Dir["EXAMPLE/*[^.o]"]
  end

  test do
    ENV.fortran
    cp_r pkgshare, testpath
    cp prefix/"make.inc", testpath
    make_args = ["CC=#{ENV.cc}",
                 "CFLAGS=-fPIC #{ENV.cflags}",
                 "FORTRAN=#{ENV.fc}",
                 "FFLAGS=#{ENV.fcflags}",
                 "SuperLUroot=#{opt_prefix}",
                 "SUPERLULIB=#{opt_lib}/libsuperlu.a",
                 "NOOPTS=-fPIC",
                 "HEADER=#{opt_include}/superlu",
                ]

    if build.with? "openblas"
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      blas = (OS.mac?) ? "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort" : "-lblas"
    end
    make_args << "BLASLIB=#{blas}"
    make_args << ("LOADOPTS=" + ((build.with? "openmp") ? "-fopenmp" : ""))

    cd "superlu" do
      system "make", *make_args

      system "./superlu"
      system "./slinsol < g20.rua"
      system "./slinsolx  < g20.rua"
      system "./slinsolx1 < g20.rua"
      system "./slinsolx2 < g20.rua"

      system "./dlinsol < g20.rua"
      system "./dlinsolx  < g20.rua"
      system "./dlinsolx1 < g20.rua"
      system "./dlinsolx2 < g20.rua"

      system "./clinsol < cg20.cua"
      system "./clinsolx < cg20.cua"
      system "./clinsolx1 < cg20.cua"
      system "./clinsolx2 < cg20.cua"

      system "./zlinsol < cg20.cua"
      system "./zlinsolx < cg20.cua"
      system "./zlinsolx1 < cg20.cua"
      system "./zlinsolx2 < cg20.cua"

      system "./sitersol -h < g20.rua" # broken with Accelerate
      system "./sitersol1 -h < g20.rua"
      system "./ditersol -h < g20.rua"
      system "./ditersol1 -h < g20.rua"
      system "./citersol -h < g20.rua"
      system "./citersol1 -h < g20.rua"
      system "./zitersol -h < cg20.cua"
      system "./zitersol1 -h < cg20.cua"
    end
  end
end

__END__
diff --git a/EXAMPLE/citersol.c b/EXAMPLE/citersol.c
index 1bcd6a2..6ced186 100644
--- a/EXAMPLE/citersol.c
+++ b/EXAMPLE/citersol.c
@@ -292,7 +292,7 @@ int main(int argc, char *argv[])
     restrt = SUPERLU_MIN(n / 3 + 1, 50);
     maxit = 1000;
     iter = maxit;
-    resid = 1e-8;
+    resid = 1e-4;
     if (!(x = complexMalloc(n))) ABORT("Malloc fails for x[].");

     if (info <= n + 1)
@@ -326,7 +326,7 @@ int main(int argc, char *argv[])
	if (iter >= maxit)
	{
	    if (resid >= 1.0) iter = -180;
-	    else if (resid > 1e-8) iter = -111;
+	    else if (resid > 1e-4) iter = -111;
	}
	printf("iteration: %d\nresidual: %.1e\nGMRES time: %.2f seconds.\n",
		iter, resid, t);
diff --git a/EXAMPLE/citersol1.c b/EXAMPLE/citersol1.c
index 09036d0..836c9ac 100644
--- a/EXAMPLE/citersol1.c
+++ b/EXAMPLE/citersol1.c
@@ -304,7 +304,7 @@ int main(int argc, char *argv[])
     restrt = SUPERLU_MIN(n / 3 + 1, 50);
     maxit = 1000;
     iter = maxit;
-    resid = 1e-8;
+    resid = 1e-4;
     if (!(x = complexMalloc(n))) ABORT("Malloc fails for x[].");

     if (info <= n + 1)
@@ -338,7 +338,7 @@ int main(int argc, char *argv[])
	if (iter >= maxit)
	{
	    if (resid >= 1.0) iter = -180;
-	    else if (resid > 1e-8) iter = -111;
+	    else if (resid > 1e-4) iter = -111;
	}
	printf("iteration: %d\nresidual: %.1e\nGMRES time: %.2f seconds.\n",
		iter, resid, t);
diff --git a/EXAMPLE/sitersol.c b/EXAMPLE/sitersol.c
index fc6045c..8f0b6f7 100644
--- a/EXAMPLE/sitersol.c
+++ b/EXAMPLE/sitersol.c
@@ -291,7 +291,7 @@ int main(int argc, char *argv[])
     restrt = SUPERLU_MIN(n / 3 + 1, 50);
     maxit = 1000;
     iter = maxit;
-    resid = 1e-8;
+    resid = 1e-4;
     if (!(x = floatMalloc(n))) ABORT("Malloc fails for x[].");

     if (info <= n + 1)
@@ -325,7 +325,7 @@ int main(int argc, char *argv[])
	if (iter >= maxit)
	{
	    if (resid >= 1.0) iter = -180;
-	    else if (resid > 1e-8) iter = -111;
+	    else if (resid > 1e-4) iter = -111;
	}
	printf("iteration: %d\nresidual: %.1e\nGMRES time: %.2f seconds.\n",
		iter, resid, t);
diff --git a/EXAMPLE/sitersol1.c b/EXAMPLE/sitersol1.c
index 7d098fb..2ee355c 100644
--- a/EXAMPLE/sitersol1.c
+++ b/EXAMPLE/sitersol1.c
@@ -303,7 +303,7 @@ int main(int argc, char *argv[])
     restrt = SUPERLU_MIN(n / 3 + 1, 50);
     maxit = 1000;
     iter = maxit;
-    resid = 1e-8;
+    resid = 1e-4;
     if (!(x = floatMalloc(n))) ABORT("Malloc fails for x[].");

     if (info <= n + 1)
@@ -337,7 +337,7 @@ int main(int argc, char *argv[])
	if (iter >= maxit)
	{
	    if (resid >= 1.0) iter = -180;
-	    else if (resid > 1e-8) iter = -111;
+	    else if (resid > 1e-4) iter = -111;
	}
	printf("iteration: %d\nresidual: %.1e\nGMRES time: %.2f seconds.\n",
		iter, resid, t);
