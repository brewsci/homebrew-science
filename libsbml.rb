class Libsbml < Formula
  desc "Systems Biology Markup Language (SBML)"
  homepage "http://sbml.org/Software/libSBML"
  url "https://downloads.sourceforge.net/project/sbml/libsbml/5.15.0/stable/libSBML-5.15.0-core-plus-packages-src.tar.gz"
  sha256 "c779c2a8a97c5480fe044028099d928a327261fb68cf08657ec8d4f3b3fc0a21"

  bottle do
    cellar :any
    sha256 "58ddad748fc30492381a0d788d54a56cb31f89a90a0b4c87d061dcd5b7c12bf8" => :sierra
    sha256 "d2126439d2afacb0f6329840687bb2ca4a16338b0683375e118b8ab222e26573" => :el_capitan
    sha256 "ade741b74948b3b958f2a099244bc46454eb3b3b96af683180cc3bb907bd1a7c" => :yosemite
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

  # fix ruby's sitelib dir
  patch :DATA

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"

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
