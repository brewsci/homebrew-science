require 'formula'

class Cantera < Formula
  homepage 'http://code.google.com/p/cantera/'
  head 'https://github.com/cantera/cantera.git', :branch => 'master'

  stable do
    url "https://downloads.sourceforge.net/project/cantera/cantera/2.1.2/cantera-2.1.2.tar.gz"
    sha1 "57c3ddf112d5b27cb423f064fc84dcaa6ba14a1f"
    # Patches to checkFinite.cpp and SConstruct should be removed for
    # Cantera 2.2.x (fixed upstream)
    patch :DATA
  end

  option "with-matlab=", "Path to Matlab root directory"
  option "without-check", "Disable build-time checking (not recommended)"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "scons" => :build
  depends_on "numpy" => :python
  depends_on "cython" => :python
  depends_on "sundials" => :recommended
  depends_on :python3 => :optional
  depends_on "graphviz" => :optional

  def install
    # Make sure to use Homebrew Python to do CTI to CTML conversions
    inreplace "src/base/ct2ctml.cpp", 's = "python";', 's = "/usr/local/bin/python";'

    build_args = ["prefix=#{prefix}",
                  "python_package=new",
                  "CC=#{ENV.cc}",
                  "CXX=#{ENV.cxx}",
                  "f90_interface=n"]

    matlab_path = ARGV.value("with-matlab")
    build_args << "matlab_path=" + matlab_path if matlab_path
    build_args << "python3_package=y" if build.with? :python3

    # This is needed to make sure both the main code and the Python module use
    # the same C++ standard library. Can be removed for Cantera 2.2.x
    if MacOS.version >= :mavericks and not build.head?
      ENV.libcxx
      build_args << "python_compiler=#{ENV.cxx}"
    end

    scons "build", *build_args
    scons "test" if build.with? "check"
    scons "install"
    prefix.install Dir["License.*"]
  end

  test do
    # Run those portions of the test suite that do not depend of data
    # that's only available in the source tree.
    system("python", "-m", "unittest", "-v",
           "cantera.test.test_thermo",
           "cantera.test.test_kinetics",
           "cantera.test.test_transport",
           "cantera.test.test_purefluid",
           "cantera.test.test_mixture")
  end

  def caveats; <<-EOS.undent
    The license, demos, tutorials, data, etc. can be found in:
      #{opt_prefix}

    Try the following in python to find the equilibrium composition of a
    stoichiometric methane/air mixture at 1000 K and 1 atm:
    >>> import cantera as ct
    >>> g = ct.Solution('gri30.cti')
    >>> g.TPX = 1000, ct.one_atm, 'CH4:1, O2:2, N2:8'
    >>> g.equilibrate('TP')
    >>> g()
    EOS
  end
end

__END__
diff --git a/src/base/checkFinite.cpp b/src/base/checkFinite.cpp
index 41384ca..7ac6785 100644
--- a/src/base/checkFinite.cpp
+++ b/src/base/checkFinite.cpp
@@ -55,10 +55,10 @@ void checkFinite(const double tmp)
         throw std::range_error("checkFinite()");
     }
 #else
-    if (!::finite(tmp)) {
-        if (::isnan(tmp)) {
+    if (!std::isfinite(tmp)) {
+        if (std::isnan(tmp)) {
             printf("checkFinite() ERROR: we have encountered a nan!\n");
-        } else if (::isinf(tmp) == 1) {
+        } else if (std::isinf(tmp) == 1) {
             printf("checkFinite() ERROR: we have encountered a pos inf!\n");
         } else {
             printf("checkFinite() ERROR: we have encountered a neg inf!\n");
diff --git a/SConstruct b/SConstruct
index 13b8600..bca9e8a 100644
--- a/SConstruct
+++ b/SConstruct
@@ -1126,7 +1126,7 @@ else:
         env['inst_datadir'] = pjoin(instRoot, 'share', 'cantera', 'data')
         env['inst_sampledir'] = pjoin(instRoot, 'share', 'cantera', 'samples')
         env['inst_docdir'] = pjoin(instRoot, 'share', 'cantera', 'doc')
-        env['inst_mandir'] = pjoin(instRoot, 'man', 'man1')
+        env['inst_mandir'] = pjoin(instRoot, 'share', 'man', 'man1')
 
 # **************************************
 # *** Set options needed in config.h ***
