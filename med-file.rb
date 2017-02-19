class MedFile < Formula
  desc "MEDFile - Modeling and Data Exchange standardized format"
  homepage "http://www.salome-platform.org"
  url "http://files.salome-platform.org/Salome/other/med-3.2.0.tar.gz"
  sha256 "d52e9a1bdd10f31aa154c34a5799b48d4266dc6b4a5ee05a9ceda525f2c6c138"

  bottle do
    cellar :any
    sha256 "dcf654be1b4a2465b9499304e97e0a9219bda76ff313e099669d405039554425" => :sierra
    sha256 "8a6b484c712b37c888c1343b029e2dda5f55eaf6345f5a31eb855083c89f1115" => :el_capitan
    sha256 "40d8d84eb6ff3ea04fcb7e8dff7ac2c0c8834c6358ba06af8ed5430a3e3a308e" => :yosemite
  end

  option "with-fortran",   "Install Fortran bindings"
  option "without-python", "Do not install Python bindings"
  option "with-test",      "Install tests"
  option "with-docs",      "Install documentation"

  depends_on "cmake"  => :build
  depends_on :python  => :build if build.with? "python"
  depends_on "swig"   => :build if build.with? "python"
  depends_on :fortran => :build if build.with? "fortran"
  depends_on "homebrew/science/hdf5"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/720fedf/med-file/libc%2B%2B_and_python_bindings_fixes.diff"
    sha256 "4125238ca3623e682b766cf2d34fed17938007ad326ae3b158a9cd427c638054"
  end

  def install
    cmake_args = std_cmake_args

    cmake_args << "-DCMAKE_Fortran_COMPILER:BOOL=OFF" if build.without? "fortran"
    cmake_args << "-DMEDFILE_BUILD_TESTS:BOOL=OFF"    if build.without? "tests"
    cmake_args << "-DMEDFILE_INSTALL_DOC:BOOL=OFF"    if build.without? "docs"

    if build.with? "python"
      python_prefix=`#{HOMEBREW_PREFIX}/bin/python-config --prefix`.chomp
      python_include=Dir["#{python_prefix}/include/*"].first
      python_library=Dir["#{python_prefix}/lib/libpython*" + (OS.mac? ? ".dylib" : ".so")].first

      cmake_args << "-DMEDFILE_BUILD_PYTHON:BOOL=ON"
      cmake_args << "-DPYTHON_INCLUDE_DIR:PATH=#{python_include}"
      cmake_args << "-DPYTHON_LIBRARY:FILEPATH=#{python_library}"
    end

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Nombre de parametre incorrect : medimport filein [fileout]", shell_output("#{bin}/medimport 2>&1", 255)
    (testpath/"test.c").write <<-EOS.undent
      #include <med.h>
      int main() {
        med_int major, minor, release;
        return MEDlibraryNumVersion(&major, &minor, &release);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L/usr/local/lib", "-lmedC", "-o", "test"
    system "./test"
  end
end
