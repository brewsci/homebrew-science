class Libsbml < Formula
  desc "Systems Biology Markup Language (SBML)"
  homepage "http://sbml.org/Software/libSBML"
  url "https://downloads.sourceforge.net/project/sbml/libsbml/5.16.0/stable/libSBML-5.16.0-core-plus-packages-src.tar.gz"
  sha256 "c6855481434dd2a667fef73e1ff2feade509aa2f3a76d4d06e29022975ce1496"

  bottle do
    cellar :any
    sha256 "164571619c5e873e831679632454b0ec81841488e20b31fdec53bb267cdc617a" => :high_sierra
    sha256 "e34da5cb0002c70afb996d6cecbd3e1bb4afd98799ccbcc0b0477c5568d42e7e" => :sierra
    sha256 "9e6b76c0ab1f0f66a518329e1e51de13f61216c0c31ab70c2335e136d9c2206e" => :el_capitan
    sha256 "195e62f7a0c0f0800e71163144b38e6acffc06ec54a6a3047e63749d58a5c13c" => :x86_64_linux
  end

  LANGUAGES_OPTIONAL = {
    "csharp" => "C#",
    "java" => "Java",
    "matlab" => "MATLAB",
    "octave" => "Octave",
    "perl" => "Perl",
    "ruby" => "Ruby",
    "python" => "Python",
    "r" => "R",
  }.freeze

  LANGUAGES_OPTIONAL.each do |opt, lang|
    option "with-#{opt}", "generate #{lang} interface library [default=no]"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on :python => :optional
  depends_on "libxml2" unless OS.mac?

  # fix ruby's sitelib dir
  patch :DATA

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"

      unless OS.mac?
        args << "-DLIBXML_INCLUDE_DIR=#{Formula["libxml2"].opt_include}/libxml2"
      end

      if build.with? "python"
        args << "-DWITH_PYTHON=ON"
        args << "-DPYTHON_EXECUTABLE='#{`python-config --prefix`.chomp}/bin/python'"
        args << "-DPYTHON_INCLUDE_DIR='#{`python-config --prefix`.chomp}/include/python2.7'"
        args << "-DPYTHON_LIBRARY='#{`python-config --prefix`.chomp}/lib/libpython2.7.dylib'"
      end

      args << "-DWITH_CSHARP=ON" if build.with? "csharp"
      args << "-DWITH_JAVA=ON" if build.with? "java"
      args << "-DWITH_MATLAB=ON" if build.with? "matlab"
      args << "-DWITH_OCTAVE=ON" if build.with? "octave"
      args << "-DWITH_PERL=ON" if build.with? "perl"
      args << "-DWITH_RUBY=ON" if build.with? "ruby"
      args << "-DWITH_R=ON" if build.with? "r"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <sbml/SBMLTypes.h>
      int main() {
        SBMLDocument_t *d = SBMLDocument_createWithLevelAndVersion(3, 2);
        SBMLDocument_free(d);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsbml", "-o", "test"
    system "./test"
  end
end

__END__
--- a/src/bindings/ruby/CMakeLists.txt    2015-02-17 21:32:41.000000000 +0900
+++ a/src/bindings/ruby/CMakeLists.txt    2015-02-17 21:33:57.000000000 +0900
@@ -170,7 +170,7 @@
 if (UNIX OR CYGWIN)
   execute_process(COMMAND "${RUBY_EXECUTABLE}" -e "print RUBY_PLATFORM"
     OUTPUT_VARIABLE RUBY_PLATFORM)
-  set(RUBY_PACKAGE_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR}/ruby/site_ruby/${RUBY_VERSION_MAJOR}.${RUBY_VERSION_MINOR}/${RUBY_PLATFORM})
+  string(REPLACE ${RUBY_POSSIBLE_LIB_DIR} ${CMAKE_INSTALL_LIBDIR} RUBY_PACKAGE_INSTALL_DIR ${RUBY_SITEARCH_DIR})
 else()
   set(RUBY_PACKAGE_INSTALL_DIR ${MISC_PREFIX}bindings/ruby)
 endif()
