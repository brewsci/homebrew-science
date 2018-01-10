class MedFile < Formula
  desc "Modeling and Data Exchange standardized format"
  homepage "http://www.salome-platform.org"
  url "http://files.salome-platform.org/Salome/other/med-3.2.0.tar.gz"
  sha256 "d52e9a1bdd10f31aa154c34a5799b48d4266dc6b4a5ee05a9ceda525f2c6c138"
  revision 1

  bottle do
    cellar :any
    sha256 "7306f7b36ada75fc21fd9ff9763ef9a1d1cf9c0d874aab06c1513a20fb6a66c5" => :sierra
    sha256 "75313479ba3d7b238b3eef2979ee78fed583fb5be5902f337f72269bafa26879" => :el_capitan
    sha256 "f082a9d31d2ba6caa98f34e16212aa8e0e22154efe3b4fd86933f324ddc642a9" => :yosemite
    sha256 "6a90225707e24107baa16494ed49d9308f814e87a96bb616cf07b9a3b91fc256" => :x86_64_linux
  end

  option "with-fortran",   "Install Fortran bindings"
  option "with-test",      "Install tests"
  option "with-docs",      "Install documentation"

  depends_on "cmake"  => :build
  depends_on :python  => :recommended
  depends_on "swig"   => :build if build.with? "python"
  depends_on :fortran => :build if build.with? "fortran"
  depends_on "hdf5"

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
