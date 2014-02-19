require 'formula'

class Vtk < Formula
  homepage 'http://www.vtk.org'
  url 'http://www.vtk.org/files/release/6.1/VTK-6.1.0.tar.gz'
  sha1 '91d1303558c7276f031f8ffeb47b4233f2fd2cd9'

  head 'https://github.com/Kitware/VTK.git'

  option :cxx11

  depends_on 'cmake' => :build
  depends_on :x11 => :optional
  depends_on 'qt' => :optional
  depends_on :python => :recommended
  depends_on 'boost' => :recommended
  depends_on :fontconfig => :recommended
  depends_on 'hdf5' => :recommended
  depends_on 'jpeg' => :recommended
  depends_on :libpng => :recommended
  depends_on 'libtiff' => :recommended
  depends_on 'matplotlib' => [:python, :optional]

  # If --with-qt and --with-python, then we automatically use PyQt, too!
  if build.with? 'qt'
    if build.with? 'python'
      depends_on 'sip'
      depends_on 'pyqt'
    end
  end

  option 'examples',  'Compile and install various examples'
  option 'qt-extern', 'Enable Qt4 extension via non-Homebrew external Qt4'
  option 'tcl',       'Enable Tcl wrapping of VTK classes'
  option 'with-matplotlib', 'Enable matplotlib support'
  option 'remove-legacy', 'Disable legacy APIs'

  def install
    args = std_cmake_args + %W[
      -DVTK_REQUIRED_OBJCXX_FLAGS=''
      -DVTK_USE_CARBON=OFF
      -DVTK_USE_TK=OFF
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DIOKit:FILEPATH=#{MacOS.sdk_path}/System/Library/Frameworks/IOKit.framework
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DVTK_USE_SYSTEM_EXPAT=ON
      -DVTK_USE_SYSTEM_LIBXML2=ON
      -DVTK_USE_SYSTEM_ZLIB=ON
    ]

    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')

    if build.with? 'qt' or build.include? 'qt-extern'
      args << '-DVTK_Group_Qt=ON'
    end

    args << '-DVTK_WRAP_TCL=ON' if build.include? 'tcl'

    # Cocoa for everything except x11
    if build.with? 'x11'
      args << '-DVTK_USE_COCOA=OFF'
      args << '-DVTK_USE_X=ON'
    else
      args << '-DVTK_USE_COCOA=ON'
    end

    unless MacOS::CLT.installed?
      # We are facing an Xcode-only installation, and we have to keep
      # vtk from using its internal Tk headers (that differ from OSX's).
      args << "-DTK_INCLUDE_PATH:PATH=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Headers"
      args << "-DTK_INTERNAL_PATH:PATH=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Headers/tk-private"
    end

    args << '-DModule_vtkInfovisBoost=ON' << '-DModule_vtkInfovisBoostGraphAlgorithms=ON' if build.with? 'boost'
    args << '-DModule_vtkRenderingFreeTypeFontConfig=ON' if build.with? 'fontconfig'
    args << '-DVTK_USE_SYSTEM_HDF5=ON' if build.with? 'hdf5'
    args << '-DVTK_USE_SYSTEM_JPEG=ON' if build.with? 'jpeg'
    args << '-DVTK_USE_SYSTEM_PNG=ON' if build.with? :libpng
    args << '-DVTK_USE_SYSTEM_TIFF=ON' if build.with? 'libtiff'
    args << '-DModule_vtkRenderingMatplotlib=ON' if build.with? 'matplotlib'
    args << '-DVTK_LEGACY_REMOVE=ON' if build.include? 'remove-legacy'

    ENV.cxx11 if build.cxx11?

    mkdir 'build' do
      if build.with? "python"
        args << '-DVTK_WRAP_PYTHON=ON'
        # CMake picks up the system's python dylib, even if we have a brewed one.
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
        # Set the prefix for the python bindings to the Cellar
        args << "-DVTK_INSTALL_PYTHON_MODULE_DIR='#{lib}/python2.7/site-packages'"
        if build.with? 'pyqt'
          args << '-DVTK_WRAP_PYTHON_SIP=ON'
          args << "-DSIP_PYQT_DIR='#{HOMEBREW_PREFIX}/share/sip'"
        end
      end
      args << ".."
      system "cmake", *args
      system "make"
      system "make", "install"
    end

    (share+'vtk').install 'Examples' if build.include? 'examples'
  end

  def caveats
    s = ''
    s += <<-EOS.undent
        Even without the --with-qt option, you can display native VTK render windows
        from python. Alternatively, you can integrate the RenderWindowInteractor
        in PyQt, PySide, Tk or Wx at runtime. Read more:
            import vtk.qt4; help(vtk.qt4) or import vtk.wx; help(vtk.wx)

    EOS

    if build.include? 'examples'
      s += <<-EOS.undent

        The scripting examples are stored in #{HOMEBREW_PREFIX}/share/vtk

      EOS
    end
    return s.empty? ? nil : s
  end

end
