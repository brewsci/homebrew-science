require 'formula'

class Vtk < Formula
  homepage 'http://www.vtk.org'
  url 'http://www.vtk.org/files/release/6.0/vtk-6.0.0.tar.gz'
  sha1 '51dd3b4a779d5442dd74375363f0f0c2d6eaf3fa'

  head 'https://github.com/Kitware/VTK.git'

  depends_on 'cmake' => :build
  depends_on :x11 => :optional
  depends_on 'qt' => :optional
  depends_on :python => :recommended

  # If --with-qt and --with-python, then we automatically use PyQt, too!
  if build.with? 'qt'
    if build.with? 'python3'
      depends_on 'sip'  => 'with-python3' # because python3 is optional for sip
      depends_on 'pyqt' => 'with-python3' # because python3 is optional for pyqt
    elsif build.with? 'python'
      depends_on 'sip'
      depends_on 'pyqt'
    end
  end

  option 'examples',  'Compile and install various examples'
  option 'qt-extern', 'Enable Qt4 extension via non-Homebrew external Qt4'
  option 'tcl',       'Enable Tcl wrapping of VTK classes'

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
    ]

    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')

    if build.with? 'qt' or build.include? 'qt-extern'
      args << '-DVTK_USE_GUISUPPORT=ON'
      args << '-DVTK_USE_QT=ON'
      args << '-DVTK_USE_QVTK=ON'
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

    mkdir 'build' do
      python do
        args << '-DVTK_WRAP_PYTHON=ON'
        # For Xcode-only systems, the headers of system's python are inside of Xcode:
        args << "-DPYTHON_INCLUDE_DIR='#{python.incdir}'"
        # Cmake picks up the system's python dylib, even if we have a brewed one:
        args << "-DPYTHON_LIBRARY='#{python.libdir}/lib#{python.xy}.dylib'"
        # Set the prefix for the python bindings to the Cellar
        args << "-DVTK_PYTHON_SETUP_ARGS:STRING='--prefix=#{prefix} --single-version-externally-managed --record=installed.txt'"
        if build.with? 'pyqt'
          args << '-DVTK_WRAP_PYTHON_SIP=ON'
          args << "-DSIP_PYQT_DIR='#{HOMEBREW_PREFIX}/share/sip#{python.if3then3}'"
        end
        # The make and make install have to be inside the python do loop
        # because the PYTHONPATH is defined by this block (and not outside)
        args << ".."
        system 'cmake', *args
        system 'make'
        system 'make install'
      end
      if not python then  # no python bindings
        args << ".."
        system 'cmake', *args
        system 'make'
        system 'make install'
      end
    end

    (share+'vtk').install 'Examples' if build.include? 'examples'
  end

  def caveats
    s = ''
    s += python.standard_caveats if python
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
