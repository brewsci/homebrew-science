class Insighttoolkit < Formula
  desc "ITK is a toolkit for performing registration and segmentation"
  homepage "http://www.itk.org"
  url "https://downloads.sourceforge.net/project/itk/itk/4.8/InsightToolkit-4.8.2.tar.gz"
  sha256 "d8d5e3aea700588c60b01418c440b2d95b517ea18dd4c834c5164354e53596af"
  head "git://itk.org/ITK.git"
  revision 1

  bottle do
    sha256 "ef74a82fd974bea4b347493dc377716a11b1c0e9888e1977e5dd7a0e451c23a5" => :el_capitan
    sha256 "6bdd195c9b14fc970a42e7043c0ad1d65f039349f6bf3eecf9d62f6660e22e60" => :yosemite
    sha256 "b283d65f09eccfb9bee87729403c7eeba95ce050ba22279cd2b366104341650d" => :mavericks
  end

  option :cxx11
  cxx11dep = (build.cxx11?) ? ["c++11"] : []

  depends_on "cmake" => :build
  depends_on "vtk" => [:build] + cxx11dep
  depends_on "opencv" => [:optional] + cxx11dep
  depends_on :python => :optional
  depends_on :python3 => :optional
  depends_on "fftw" => :recommended
  depends_on "hdf5" => [:recommended] + cxx11dep
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "gdcm" => [:optional] + cxx11dep

  deprecated_option "examples" => "with-examples"
  deprecated_option "remove-legacy" => "with-remove-legacy"

  option "with-examples", "Compile and install various examples"
  option "with-itkv3-compatibility", "Include ITKv3 compatibility"
  option "with-remove-legacy", "Disable legacy APIs"

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DITK_USE_GPU=ON
      -DITK_USE_64BITS_IDS=ON
      -DITK_USE_STRICT_CONCEPT_CHECKING=ON
      -DITK_USE_SYSTEM_ZLIB=ON
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DModule_SCIFIO=ON
    ]
    args << ".."
    args << "-DBUILD_EXAMPLES=" + ((build.include? "examples") ? "ON" : "OFF")
    args << "-DModule_ITKVideoBridgeOpenCV=" + ((build.with? "opencv") ? "ON" : "OFF")
    args << "-DITKV3_COMPATIBILITY:BOOL=" + ((build.with? "itkv3-compatibility") ? "ON" : "OFF")

    args << "-DITK_USE_SYSTEM_FFTW=ON" << "-DITK_USE_FFTWF=ON" << "-DITK_USE_FFTWD=ON" if build.with? "fftw"
    args << "-DITK_USE_SYSTEM_HDF5=ON" if build.with? "hdf5"
    args << "-DITK_USE_SYSTEM_JPEG=ON" if build.with? "jpeg"
    args << "-DITK_USE_SYSTEM_PNG=ON" if build.with? :libpng
    args << "-DITK_USE_SYSTEM_TIFF=ON" if build.with? "libtiff"
    args << "-DITK_USE_SYSTEM_GDCM=ON" if build.with? "gdcm"
    args << "-DITK_LEGACY_REMOVE=ON" if build.include? "remove-legacy"

    # These 3 modules are not supported with python3. Set them to OFF in this case.
    args << "-DModule_ITKLevelSetsv4Visualization=" + ((build.with? "python3") ? "OFF" : "ON")
    args << "-DModule_ITKReview=" + ((build.with? "python3") ? "OFF" : "ON")
    args << "-DModule_ITKVtkGlue=" + ((build.with? "python3") ? "OFF" : "ON")

    args << "-DVCL_INCLUDE_CXX_0X=ON" if build.cxx11?
    ENV.cxx11 if build.cxx11?

    mkdir "itk-build" do
      if build.with?("python") || build.with?("python3")

        args << "-DITK_WRAP_PYTHON=ON"

        # CMake picks up the system's python dylib, even if we have a brewed one.
        if build.with? "python"
          args << "-DPYTHON_LIBRARY='#{`python-config --prefix`.chomp}/lib/libpython2.7.dylib'"
          args << "-DPYTHON_INCLUDE_DIR='#{`python-config --prefix`.chomp}/include/python2.7'"
        elsif build.with? "python3"
          ENV["PYTHONPATH"] = lib/"python3.5/site-packages"
          args << "-DPYTHON_EXECUTABLE='#{`python3-config --prefix`.chomp}/bin/python3'"
          args << "-DPYTHON_LIBRARY='#{`python3-config --prefix`.chomp}/lib/libpython3.5.dylib'"
          args << "-DPYTHON_INCLUDE_DIR='#{`python3-config --prefix`.chomp}/include/python3.5m'"
        end

      end
      system "cmake", *args
      system "make", "install"
    end
  end
end
