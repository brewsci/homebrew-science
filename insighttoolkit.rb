require 'formula'

class Insighttoolkit < Formula
  homepage 'http://www.itk.org'
  url 'https://downloads.sourceforge.net/project/itk/itk/4.6/InsightToolkit-4.6.1.tar.gz'
  sha1 '95b879b17a8e2c4727b363037a3af4377095422d'
  head 'git://itk.org/ITK.git'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "d8f0ae99428ccaa70b18a4f229b911f51b670e9a" => :yosemite
    sha1 "38f1651c55c610d2456eef85f352b212f78c1db9" => :mavericks
    sha1 "9ac11da3dd7f9a0556bb69a7634dbba871779ade" => :mountain_lion
  end

  option :cxx11
  cxx11dep = (build.cxx11?) ? ['c++11'] : []

  depends_on 'cmake' => :build
  depends_on 'vtk' => [:build] + cxx11dep
  depends_on 'opencv' => [:optional] + cxx11dep
  depends_on :python => :optional
  depends_on 'fftw' => :recommended
  depends_on 'hdf5' => [:recommended, "with-cxx"] + cxx11dep
  depends_on 'jpeg' => :recommended
  depends_on "libpng" => :recommended
  depends_on 'libtiff' => :recommended
  depends_on 'gdcm' => [:optional] + cxx11dep

  option 'examples', 'Compile and install various examples'
  option 'with-itkv3-compatibility', 'Include ITKv3 compatibility'
  option 'remove-legacy', 'Disable legacy APIs'
  option 'with-review', 'Enable modules under review'

  if build.with? 'python'
    onoe <<-EOS.undent
      Building ITK with Python Wrapping is currently not working out of the box on Mac.
      A fix will eventually come as the ITK community is currently working on this.
      Working Python binaries can be found here : https://github.com/iMichka/homebrew-MacVTKITKPythonBottles
      EOS
    exit 1
  end

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DITK_USE_GPU=ON
      -DITK_USE_64BITS_IDS=ON
      -DITK_USE_STRICT_CONCEPT_CHECKING=ON
      -DITK_USE_SYSTEM_ZLIB=ON
      -DModule_ITKLevelSetsv4Visualization=ON
      -DModule_SCIFIO=ON
    ]
    args << ".."
    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')
    args << '-DModule_ITKVideoBridgeOpenCV=' + ((build.with? 'opencv') ? 'ON' : 'OFF')
    args << '-DITKV3_COMPATIBILITY:BOOL=' + ((build.with? 'itkv3-compatibility') ? 'ON' : 'OFF')

    args << '-DITK_USE_SYSTEM_FFTW=ON' << '-DITK_USE_FFTWF=ON' << '-DITK_USE_FFTWD=ON' if build.with? 'fftw'
    args << '-DITK_USE_SYSTEM_HDF5=ON' if build.with? 'hdf5'
    args << '-DITK_USE_SYSTEM_JPEG=ON' if build.with? 'jpeg'
    args << '-DITK_USE_SYSTEM_PNG=ON' if build.with? :libpng
    args << '-DITK_USE_SYSTEM_TIFF=ON' if build.with? 'libtiff'
    args << '-DITK_USE_SYSTEM_GDCM=ON' if build.with? 'gdcm'
    args << '-DITK_LEGACY_REMOVE=ON' if build.include? 'remove-legacy'
    args << '-DModule_ITKReview=ON' if build.with? 'review'

    args << '-DVCL_INCLUDE_CXX_0X=ON' if build.cxx11?
    ENV.cxx11 if build.cxx11?

    mkdir 'itk-build' do
      if build.with? "python"
        args += %W[
          -DITK_WRAP_PYTHON=ON
          -DModule_ITKVtkGlue=ON
          -DCMAKE_C_FLAGS='-ansi'
        ]
        # CMake picks up the system's python dylib, even if we have a brewed one.
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      end
      system "cmake", *args
      system "make", "install"
    end
  end
end
