class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.11.0.tar.gz"
  sha256 "4d666cc33296b4c5cd77bad18ffc487b3223d4bbb7d1dfb342ed9a87dc9af844"
  revision 4

  head "https://ceres-solver.googlesource.com/ceres-solver.git"

  bottle do
    cellar :any
    sha256 "48c1879d3a5911c73b3f0e542a56ce9d7e572965c2b007efe5fdfb44725b4a91" => :sierra
    sha256 "032a6dab63945adddcd4c56f6918769560062b2d9546c0df75b069161daa1482" => :el_capitan
    sha256 "a65cbaad28b944e27ca8ce21daa73a497e1e4512208a33a97689ad0b38c0c5b6" => :yosemite
  end

  devel do
    url "http://ceres-solver.org/ceres-solver-1.12.0rc1.tar.gz"
    sha256 "46d08bc2a56adac8cca1112ddaaa07c8cdce624358a184e46a173da87ff047c4"

    patch :DATA # remove at next release candidate
  end

  option "without-test", "Do not build and run the tests (not recommended)."
  deprecated_option "without-tests" => "without-test"

  depends_on "cmake" => :run
  depends_on "glog"
  depends_on "gflags"
  depends_on "eigen"
  depends_on "suite-sparse" => :recommended
  depends_on "openblas" => :recommended if build.without?("suitesparse") && OS.linux?

  def install
    so = OS.mac? ? "dylib" : "so"
    cmake_args = std_cmake_args + ["-DBUILD_SHARED_LIBS=ON"]
    cmake_args << "-DMETIS_LIBRARY=#{Formula["metis"].opt_lib}/libmetis.#{so}"
    cmake_args << "-DEIGEN_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3"
    cmake_args << "-DBUILD_DOCUMENTATION=ON" if build.head?
    system "cmake", ".", *cmake_args
    system "make"

    # tests are currently broken on linux:
    # https://groups.google.com/forum/#!topic/ceres-solver/S0gDJrWJcdE
    system "make", "test" if build.with?("test") && OS.mac?
    system "make", "install"
    pkgshare.install "examples"
    pkgshare.install "data"
    doc.install "docs/html"
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<-EOS.undent
      cmake_minimum_required(VERSION 2.8)
      project(helloworld)
      find_package(Ceres REQUIRED)
      include_directories(${CERES_INCLUDE_DIRS})
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld ${CERES_LIBRARIES})
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld", 0)
  end
end

__END__
diff --git a/internal/ceres/gradient_checker_test.cc b/internal/ceres/gradient_checker_test.cc
index 3d40a4d..54e528f 100644
--- a/internal/ceres/gradient_checker_test.cc
+++ b/internal/ceres/gradient_checker_test.cc
@@ -414,8 +414,8 @@ TEST(GradientChecker, TestCorrectnessWithLocalParameterizations) {

   Matrix residual_expected = residual_offset + j0 * param0 + j1 * param1;

-  EXPECT_TRUE(j1_out == j0);
-  EXPECT_TRUE(j2_out == j1);
+  ExpectMatricesClose(j1_out, j0, std::numeric_limits<double>::epsilon());
+  ExpectMatricesClose(j2_out, j1, std::numeric_limits<double>::epsilon());
   ExpectMatricesClose(residual, residual_expected, kTolerance);

   // Create local parameterization.
@@ -433,7 +433,9 @@ TEST(GradientChecker, TestCorrectnessWithLocalParameterizations) {

   Eigen::Matrix<double, 3, 2, Eigen::RowMajor> global_J_local_out;
   parameterization.ComputeJacobian(x.data(), global_J_local_out.data());
-  EXPECT_TRUE(global_J_local_out == global_J_local);
+  ExpectMatricesClose(global_J_local_out,
+                      global_J_local,
+                      std::numeric_limits<double>::epsilon());

   Eigen::Vector3d x_plus_delta;
   parameterization.Plus(x.data(), delta.data(), x_plus_delta.data());
@@ -472,16 +474,21 @@ TEST(GradientChecker, TestCorrectnessWithLocalParameterizations) {

   // Check that results contain correct data.
   ASSERT_EQ(results.return_value, true);
-  ASSERT_TRUE(results.residuals == residual);
+  ExpectMatricesClose(
+      results.residuals, residual, std::numeric_limits<double>::epsilon());
   CheckDimensions(results, parameter_sizes, local_parameter_sizes, 3);
   ExpectMatricesClose(results.local_jacobians.at(0), j0 * global_J_local,
                       kTolerance);
-  EXPECT_TRUE(results.local_jacobians.at(1) == j1);
+  ExpectMatricesClose(results.local_jacobians.at(1),
+                      j1,
+                      std::numeric_limits<double>::epsilon());
   ExpectMatricesClose(results.local_numeric_jacobians.at(0),
                       j0 * global_J_local, kTolerance);
   ExpectMatricesClose(results.local_numeric_jacobians.at(1), j1, kTolerance);
-  EXPECT_TRUE(results.jacobians.at(0) == j0);
-  EXPECT_TRUE(results.jacobians.at(1) == j1);
+  ExpectMatricesClose(
+      results.jacobians.at(0), j0, std::numeric_limits<double>::epsilon());
+  ExpectMatricesClose(
+      results.jacobians.at(1), j1, std::numeric_limits<double>::epsilon());
   ExpectMatricesClose(results.numeric_jacobians.at(0), j0, kTolerance);
   ExpectMatricesClose(results.numeric_jacobians.at(1), j1, kTolerance);
   EXPECT_GE(results.maximum_relative_error, 0.0);
@@ -506,18 +513,22 @@ TEST(GradientChecker, TestCorrectnessWithLocalParameterizations) {

   // Check that results contain correct data.
   ASSERT_EQ(results.return_value, true);
-  ASSERT_TRUE(results.residuals == residual);
+  ExpectMatricesClose(
+      results.residuals, residual, std::numeric_limits<double>::epsilon());
   CheckDimensions(results, parameter_sizes, local_parameter_sizes, 3);
   ASSERT_EQ(results.local_jacobians.size(), 2);
   ASSERT_EQ(results.local_numeric_jacobians.size(), 2);
   ExpectMatricesClose(results.local_jacobians.at(0),
                       (j0 + j0_offset) * global_J_local, kTolerance);
-  EXPECT_TRUE(results.local_jacobians.at(1) == j1);
+  ExpectMatricesClose(results.local_jacobians.at(1),
+                      j1,
+                      std::numeric_limits<double>::epsilon());
   ExpectMatricesClose(results.local_numeric_jacobians.at(0),
                       j0 * global_J_local, kTolerance);
   ExpectMatricesClose(results.local_numeric_jacobians.at(1), j1, kTolerance);
   ExpectMatricesClose(results.jacobians.at(0), j0 + j0_offset, kTolerance);
-  EXPECT_TRUE(results.jacobians.at(1) == j1);
+  ExpectMatricesClose(
+      results.jacobians.at(1), j1, std::numeric_limits<double>::epsilon());
   ExpectMatricesClose(results.numeric_jacobians.at(0), j0, kTolerance);
   ExpectMatricesClose(results.numeric_jacobians.at(1), j1, kTolerance);
   EXPECT_GT(results.maximum_relative_error, 0.0);
@@ -540,19 +551,23 @@ TEST(GradientChecker, TestCorrectnessWithLocalParameterizations) {

   // Check that results contain correct data.
   ASSERT_EQ(results.return_value, true);
-  ASSERT_TRUE(results.residuals == residual);
+  ExpectMatricesClose(
+      results.residuals, residual, std::numeric_limits<double>::epsilon());
   CheckDimensions(results, parameter_sizes, local_parameter_sizes, 3);
   ASSERT_EQ(results.local_jacobians.size(), 2);
   ASSERT_EQ(results.local_numeric_jacobians.size(), 2);
   ExpectMatricesClose(results.local_jacobians.at(0),
                       (j0 + j0_offset) * parameterization.global_J_local,
                       kTolerance);
-  EXPECT_TRUE(results.local_jacobians.at(1) == j1);
+  ExpectMatricesClose(results.local_jacobians.at(1),
+                      j1,
+                      std::numeric_limits<double>::epsilon());
   ExpectMatricesClose(results.local_numeric_jacobians.at(0),
                       j0 * parameterization.global_J_local, kTolerance);
   ExpectMatricesClose(results.local_numeric_jacobians.at(1), j1, kTolerance);
   ExpectMatricesClose(results.jacobians.at(0), j0 + j0_offset, kTolerance);
-  EXPECT_TRUE(results.jacobians.at(1) == j1);
+  ExpectMatricesClose(
+      results.jacobians.at(1), j1, std::numeric_limits<double>::epsilon());
   ExpectMatricesClose(results.numeric_jacobians.at(0), j0, kTolerance);
   ExpectMatricesClose(results.numeric_jacobians.at(1), j1, kTolerance);
   EXPECT_GE(results.maximum_relative_error, 0.0);
