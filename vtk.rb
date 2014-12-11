require "formula"

class Vtk < Formula
  homepage "http://www.vtk.org"
  url "http://www.vtk.org/files/release/6.1/VTK-6.1.0.tar.gz"
  mirror "http://fossies.org/linux/misc/VTK-6.1.0.tar.gz"
  sha1 "91d1303558c7276f031f8ffeb47b4233f2fd2cd9"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "745eb8b7c7eeb14b7226d7f075560625a8fd940d" => :yosemite
    sha1 "3f38f458c793b8fcb3c8b08e1f6174ec74e05a15" => :mavericks
    sha1 "795331c1241eaee7b41aec442e9d55cffb7ce84c" => :mountain_lion
  end

  head "https://github.com/Kitware/VTK.git"

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

  depends_on "cmake" => :build
  depends_on :x11 => :optional
  depends_on "qt" => :optional
  depends_on "qt5" => :optional
  depends_on :python => :recommended
  depends_on "boost" => :recommended
  depends_on "fontconfig" => :recommended
  depends_on "hdf5" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "matplotlib" => :python if build.with? "matplotlib"

  # If --with-qt and --with-python, then we automatically use PyQt, too!
  if build.with? "qt" or build.with? "qt5"
    if build.with? "python"
      depends_on "sip"
      depends_on "pyqt"
    end
  end

  def install
    args = std_cmake_args + %W[
      -DVTK_REQUIRED_OBJCXX_FLAGS=''
      -DVTK_USE_CARBON=OFF
      -DVTK_USE_TK=OFF
      -DBUILD_SHARED_LIBS=ON
      -DIOKit:FILEPATH=#{MacOS.sdk_path}/System/Library/Frameworks/IOKit.framework
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

    if build.with? "qt" or build.with? "qt5" or build.with? "qt-extern"
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
      if build.with? "python"
        args << "-DVTK_WRAP_PYTHON=ON"
        # CMake picks up the system"s python dylib, even if we have a brewed one.
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
        # Set the prefix for the python bindings to the Cellar
        args << "-DVTK_INSTALL_PYTHON_MODULE_DIR='#{lib}/python2.7/site-packages'"

        if build.with? "qt"
          args << "-DVTK_WRAP_PYTHON_SIP=ON"
          args << "-DSIP_PYQT_DIR='#{Formula["pyqt"].opt_share}/sip'"
        end
      end
      args << ".."
      system "cmake", *args
      system "make"
      system "make", "install"
    end

    (share+"vtk").install "Examples" if build.with? "examples"
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
    return s.empty? ? nil : s
  end

end
