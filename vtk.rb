class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization."
  homepage "http://www.vtk.org"
  url "http://www.vtk.org/files/release/7.0/VTK-7.0.0.tar.gz"
  mirror "https://fossies.org/linux/misc/VTK-7.0.0.tar.gz"
  sha256 "78a990a15ead79cdc752e86b83cfab7dbf5b7ef51ba409db02570dbdd9ec32c3"
  revision 3

  head "https://github.com/Kitware/VTK.git"

  bottle do
    sha256 "dbdd618e3a16ed47b64df25a611bf95e03459957753adcb315e51dc7bf565c19" => :el_capitan
    sha256 "430315928aaad5502eb6165995c937c2eb99578a95fa0fe405bf5d6a3632cfd4" => :yosemite
    sha256 "d33f0bcd98119786071be10e5352e75c3b7006d8f72d6deeef5be6659f4aff13" => :mavericks
  end

  deprecated_option "examples" => "with-examples"
  deprecated_option "qt-extern" => "with-qt-extern"
  deprecated_option "tcl" => "with-tcl"
  deprecated_option "remove-legacy" => "without-legacy"

  option :cxx11
  option "with-examples",   "Compile and install various examples"
  option "with-qt-extern",  "Enable Qt4 extension via non-Homebrew external Qt4"
  option "with-tcl",        "Enable Tcl wrapping of VTK classes"
  option "with-matplotlib", "Enable matplotlib support"
  option "without-legacy",  "Disable legacy APIs"
  option "without-python",  "Build without python2 support"

  depends_on "cmake" => :build
  depends_on :x11 => :optional
  depends_on "qt" => :optional
  depends_on "qt5" => :optional

  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  depends_on "boost" => :recommended
  depends_on "fontconfig" => :recommended
  depends_on "hdf5" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "matplotlib" => :python if build.with?("matplotlib") && build.with?("python")

  # If --with-qt and --with-python, then we automatically use PyQt, too!
  if build.with? "python"
    if build.with? "qt"
      depends_on "sip"
      depends_on "pyqt"
    elsif build.with? "qt5"
      depends_on "sip"
      depends_on "pyqt5" => ["with-python", "without-python3"]
    end
  end

  if build.with? "python3"
    if build.with? "qt"
      depends_on "sip" => ["with-python3", "without-python"]
      depends_on "pyqt" => ["with-python3", "without-python"]
    elsif build.with? "qt5"
      depends_on "sip"   => ["with-python3", "without-python"]
      depends_on "pyqt5"
    end
  end

  def install
    args = std_cmake_args + %W[
      -DVTK_REQUIRED_OBJCXX_FLAGS=''
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DVTK_USE_SYSTEM_EXPAT=ON
      -DVTK_USE_SYSTEM_LIBXML2=ON
      -DVTK_USE_SYSTEM_ZLIB=ON
    ]

    args << "-DBUILD_EXAMPLES=" + ((build.with? "examples") ? "ON" : "OFF")

    if build.with? "examples"
      args << "-DBUILD_TESTING=ON"
    else
      args << "-DBUILD_TESTING=OFF"
    end

    if build.with?("qt") || build.with?("qt5") || build.with?("qt-extern")
      args << "-DVTK_QT_VERSION:STRING=5" if build.with? "qt5"
      args << "-DVTK_Group_Qt=ON"
    end

    args << "-DVTK_WRAP_TCL=ON" if build.with? "tcl"

    # Cocoa for everything except x11
    if build.with? "x11"
      args << "-DVTK_USE_COCOA=OFF"
      args << "-DVTK_USE_X=ON"
    else
      args << "-DVTK_USE_COCOA=ON"
    end

    unless MacOS::CLT.installed?
      # We are facing an Xcode-only installation, and we have to keep
      # vtk from using its internal Tk headers (that differ from OSX's).
      args << "-DTK_INCLUDE_PATH:PATH=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Headers"
      args << "-DTK_INTERNAL_PATH:PATH=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Headers/tk-private"
    end

    args << "-DModule_vtkInfovisBoost=ON" << "-DModule_vtkInfovisBoostGraphAlgorithms=ON" if build.with? "boost"
    args << "-DModule_vtkRenderingFreeTypeFontConfig=ON" if build.with? "fontconfig"
    args << "-DVTK_USE_SYSTEM_HDF5=ON" if build.with? "hdf5"
    args << "-DVTK_USE_SYSTEM_JPEG=ON" if build.with? "jpeg"
    args << "-DVTK_USE_SYSTEM_PNG=ON" if build.with? "libpng"
    args << "-DVTK_USE_SYSTEM_TIFF=ON" if build.with? "libtiff"
    args << "-DModule_vtkRenderingMatplotlib=ON" if build.with? "matplotlib"
    args << "-DVTK_LEGACY_REMOVE=ON" if build.without? "legacy"

    ENV.cxx11 if build.cxx11?

    mkdir "build" do
      if build.with?("python") && build.without?("python3")
        args << "-DVTK_WRAP_PYTHON=ON"
        # CMake picks up the system"s python dylib, even if we have a brewed one.
        args << "-DPYTHON_LIBRARY='#{`python-config --prefix`.chomp}/lib/libpython2.7.dylib'"
        # Set the prefix for the python bindings to the Cellar
        args << "-DVTK_INSTALL_PYTHON_MODULE_DIR='#{lib}/python2.7/site-packages'"
      elsif build.without?("python") && build.with?("python3")
        args << "-DVTK_WRAP_PYTHON=ON"
        args << "-DPYTHON_EXECUTABLE=/usr/local/bin/python3"
        args << "-DPYTHON_INCLUDE_DIR='#{`python3-config --prefix`.chomp}/include/python3.5m'"
        # CMake picks up the system"s python dylib, even if we have a brewed one.
        args << "-DPYTHON_LIBRARY='#{`python3-config --prefix`.chomp}/lib/libpython3.5.dylib'"
        # Set the prefix for the python bindings to the Cellar
        args << "-DVTK_INSTALL_PYTHON_MODULE_DIR='#{lib}/python3.5/site-packages'"
      elsif build.with?("python3") && build.with?("python")
        # Does not currenly support building both python 2 and 3 versions
        odie "VTK: Does not currently support building both python 2 and 3 wrappers"
      end

      if build.with?("qt") || build.with?("qt5")
        args << "-DVTK_WRAP_PYTHON_SIP=ON"
        args << "-DSIP_PYQT_DIR='#{Formula["pyqt"].opt_share}/sip'" if build.with? "qt"
        args << "-DSIP_PYQT_DIR='#{Formula["pyqt5"].opt_share}/sip'" if build.with? "qt5"
      end

      args << ".."
      system "cmake", *args
      system "make"
      system "make", "install"
    end

    pkgshare.install "Examples" if build.with? "examples"
  end

  def caveats
    s = ""
    s += <<-EOS.undent
        Even without the --with-qt option, you can display native VTK render windows
        from python. Alternatively, you can integrate the RenderWindowInteractor
        in PyQt, PySide, Tk or Wx at runtime. Read more:
            import vtk.qt4; help(vtk.qt4) or import vtk.wx; help(vtk.wx)

    EOS

    if build.with? "examples"
      s += <<-EOS.undent

        The scripting examples are stored in #{HOMEBREW_PREFIX}/share/vtk

      EOS
    end
    s.empty? ? nil : s
  end

  test do
    (testpath/"Version.cpp").write <<-EOS
        #include <vtkVersion.h>
        #include <assert.h>
        int main(int, char *[])
        {
          assert (vtkVersion::GetVTKMajorVersion()==7);
          assert (vtkVersion::GetVTKMinorVersion()==1);
          return EXIT_SUCCESS;
        }
      EOS

    (testpath/"CMakeLists.txt").write <<-EOS
      cmake_minimum_required(VERSION 2.8)
      PROJECT(Version)
      find_package(VTK REQUIRED)
      include(${VTK_USE_FILE})
      add_executable( Version Version.cpp )
      target_link_libraries(Version ${VTK_LIBRARIES})
      EOS
    system "cmake", "."
    system "make && ./Version"
  end
end
