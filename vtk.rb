class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization."
  homepage "http://www.vtk.org"
  head "https://github.com/Kitware/VTK.git"

  stable do
    url "http://www.vtk.org/files/release/7.1/VTK-7.1.1.tar.gz"
    mirror "https://fossies.org/linux/misc/VTK-7.1.1.tar.gz"
    sha256 "2d5cdd048540144d821715c718932591418bb48f5b6bb19becdae62339efa75a"
    patch do
      # Fixes python linking. This is a modified version of
      # https://github.com/Kitware/VTK/commit/5668595ea778e81acaed451ae4dc1125a43a8aa0
      # This patch has been merged upstream and can be removed for the next VTK
      # release containing the patch.
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/vtk/vtk-nopythonlinking-7.1.0.patch"
      sha256 "b243eb77567f822540e299a9ee44f4fd646abb6fa3b8e889af3e69f97ff3993e"
    end
  end
  revision 1

  bottle do
    sha256 "1e78888db71fa591cddabc3672ca649af85afcbdb48d6dd4bb7c28d460128fcd" => :sierra
    sha256 "6a32ded294b08aad7a5125d0a8efb5801c61e72a4df918328aa6a62e73356594" => :el_capitan
    sha256 "a4884a0e5ee80f993b714325f21a398f1ae7fe679261d293cf3cd63504a0a496" => :yosemite
  end

  deprecated_option "examples" => "with-examples"
  deprecated_option "qt-extern" => "with-qt-extern"
  deprecated_option "tcl" => "with-tcl"
  deprecated_option "remove-legacy" => "without-legacy"
  deprecated_option "with-qt@5.7" => "with-qt5"

  option :cxx11
  option "with-examples",   "Compile and install various examples"
  option "with-qt-extern",  "Enable Qt4 extension via non-Homebrew external Qt4"
  option "with-tcl",        "Enable Tcl wrapping of VTK classes"
  option "with-matplotlib", "Enable matplotlib support"
  option "without-legacy",  "Disable legacy APIs"
  option "without-python",  "Build without python2 support"

  depends_on "netcdf"
  depends_on "cmake" => :build
  depends_on :x11 => :optional
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

  unless OS.mac?
    depends_on "libxml2"
    depends_on "linuxbrew/xorg/mesa"
  end

  # If --with-qt and --with-python, then we automatically use PyQt, too!
  if build.with? "qt5"
    if build.with? "python"
      depends_on "sip"
      depends_on "pyqt5" => ["with-python", "without-python3"]
    elsif build.with? "python3"
      depends_on "sip"   => ["with-python3", "without-python"]
      depends_on "pyqt5"
    end
  end

  def install
    dylib = OS.mac? ? "dylib" : "so"

    args = std_cmake_args + %W[
      -DVTK_REQUIRED_OBJCXX_FLAGS=''
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DVTK_USE_SYSTEM_EXPAT=ON
      -DVTK_USE_SYSTEM_LIBXML2=ON
      -DVTK_USE_SYSTEM_ZLIB=ON
      -DVTK_USE_SYSTEM_NETCDF=ON
    ]

    args << "-DBUILD_EXAMPLES=" + ((build.with? "examples") ? "ON" : "OFF")

    if build.with? "examples"
      args << "-DBUILD_TESTING=ON"
    else
      args << "-DBUILD_TESTING=OFF"
    end

    if build.with? "qt5"
      args << "-DVTK_QT_VERSION:STRING=5"
      args << "-DVTK_Group_Qt=ON"
    end

    args << "-DVTK_WRAP_TCL=ON" if build.with? "tcl"

    # Cocoa for everything except x11
    if build.with? "x11"
      args << "-DVTK_USE_COCOA=OFF"
      args << "-DVTK_USE_X=ON"
      args << "-DOPENGL_INCLUDE_DIR:PATH=/usr/X11R6/include"
      args << "-DOPENGL_gl_LIBRARY:STRING=/usr/X11R6/lib/libGL.dylib"
      args << "-DOPENGL_glu_LIBRARY:STRING=/usr/X11R6/lib/libGLU.dylib"
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
      if build.with?("python3") && build.with?("python")
        # VTK Does not support building both python 2 and 3 versions
        odie "VTK: Does not support building both python 2 and 3 wrappers"
      elsif build.with?("python") || build.with?("python3")
        python_executable = `which python`.strip if build.with? "python"
        python_executable = `which python3`.strip if build.with? "python3"

        python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
        python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
        python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp
        py_site_packages = "#{lib}/#{python_version}/site-packages"

        args << "-DVTK_WRAP_PYTHON=ON"
        args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
        args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"
        # CMake picks up the system's python dylib, even if we have a brewed one.
        if File.exist? "#{python_prefix}/Python"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.a'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.#{dylib}"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.#{dylib}'"
        elsif File.exist? "#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.#{dylib}"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.so'"
        else
          odie "No libpythonX.Y.{dylib|so|a} file found!"
        end
        # Set the prefix for the python bindings to the Cellar
        args << "-DVTK_INSTALL_PYTHON_MODULE_DIR='#{py_site_packages}/'"
      end

      if build.with? "qt5"
        args << "-DVTK_WRAP_PYTHON_SIP=ON"
        args << "-DSIP_PYQT_DIR='#{Formula["pyqt5"].opt_share}/sip'"
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
        Even without the --with-qt5 option, you can display native VTK render windows
        from python. Alternatively, you can integrate the RenderWindowInteractor
        in PyQt4, Tk or Wx at runtime. Read more:
            import vtk.qt5; help(vtk.qt5) or import vtk.wx; help(vtk.wx)
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

    system ENV.cxx, "Version.cpp", "-I#{opt_include}/vtk-7.1"
    system "./a.out"
    system "#{bin}/vtkpython", "-c", "exit()"
  end
end
