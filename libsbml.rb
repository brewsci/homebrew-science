class Libsbml < Formula
  homepage "http://sbml.org/Software/libSBML"
  url "https://downloads.sourceforge.net/project/sbml/libsbml/5.11.0/stable/libSBML-5.11.0-core-plus-packages-src.tar.gz"
  sha1 "cfe9697bf9e28758c0dbd7b7c6b6ad3a7a01c56e"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "0e924956110d4ad6b53cb44b577fed955248511a" => :yosemite
    sha1 "1f09b04dcfc191f28f733732cdd46288237d38ff" => :mavericks
    sha1 "88393f0937a02d2211f9965309833283182954b4" => :mountain_lion
  end

  LANGUAGES_OPTIONAL = {
    "csharp" => "C#",
    "java" => "Java",
    "matlab" => "MATLAB",
    "octave" => "Octave",
    "perl" => "Perl",
    "ruby" => "Ruby",
    "python" => "Python",
  }
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
        args << "-DPYTHON_EXECUTABLE='#{%x(python-config --prefix).chomp}/bin/python'"
        args << "-DPYTHON_INCLUDE_DIR='#{%x(python-config --prefix).chomp}/include/python2.7'"
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      end

      args << "-DWITH_CSHARP=ON" if build.with? "csharp"
      args << "-DWITH_JAVA=ON" if build.with? "java"
      args << "-DWITH_MATLAB=ON" if build.with? "matlab"
      args << "-DWITH_OCTAVE=ON" if build.with? "octave"
      args << "-DWITH_PERL=ON" if build.with? "perl"
      args << "-DWITH_RUBY=ON" if build.with? "ruby"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <sbml/SBMLTypes.h>
      int main() {
        SBMLDocument_t *d = SBMLDocument_createWithLevelAndVersion(3, 1);
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
