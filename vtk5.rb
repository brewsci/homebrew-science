require "formula"

class Vtk5 < Formula
  homepage "http://www.vtk.org"
  url "http://www.vtk.org/files/release/5.10/vtk-5.10.1.tar.gz"  # update libdir below, too!
  sha1 "deb834f46b3f7fc3e122ddff45e2354d69d2adc3"
  head "git://vtk.org/VTK.git", :branch => "release-5.10"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "ddebd8c0d9dc9315f36762b4179d7c4264460b0f" => :yosemite
    sha1 "365ec2a27a039bc01a7b9ffcb3ff08a2d65d169f" => :mavericks
    sha1 "78c4a464bf75f62b4b162a015562646aa9f572be" => :mountain_lion
  end

  deprecated_option "examples" => "with-examples"
  deprecated_option "qt-extern" => "with-qt-extern"
  deprecated_option "tcl" => "with-tcl"
  deprecated_option "remove-legacy" => "without-legacy"

  option :cxx11
  option "with-examples",   "Compile and install various examples"
  option "with-qt-extern",  "Enable Qt4 extension via non-Homebrew external Qt4"
  option "with-tcl",        "Enable Tcl wrapping of VTK classes"
  option "without-legacy",  "Disable legacy APIs"

  depends_on "cmake" => :build
  depends_on :x11 => :optional
  depends_on "qt" => :optional
  depends_on :python => :recommended
  # If --with-qt and --with-python, then we automatically use PyQt, too!
  if build.with? "qt" and build.with? "python"
    depends_on "sip"
    depends_on "pyqt"
  end
  depends_on "boost" => :recommended
  depends_on "hdf5" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended

  keg_only "Different versions of the same library"

  # Fix bug in Wrapping/Python/setup_install_paths.py: http://vtk.org/Bug/view.php?id=13699
  # and compilation on mavericks backported from head.
  patch :DATA

  stable do
    patch do
      # apply upstream patches for C++11 mode
      url "https://gist.github.com/sxprophet/7463815/raw/165337ae10d5665bc18f0bad645eff098f939893/vtk5-cxx11-patch.diff"
      sha1 "5511c8a48327824443f321894e3ea3ac289bf40e"
    end
  end

  def install
    libdir = if build.head? then lib; else "#{lib}/vtk-5.10"; end

    args = std_cmake_args + %W[
      -DVTK_REQUIRED_OBJCXX_FLAGS=''
      -DVTK_USE_CARBON=OFF
      -DVTK_USE_TK=OFF
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DIOKit:FILEPATH=#{MacOS.sdk_path}/System/Library/Frameworks/IOKit.framework
      -DCMAKE_INSTALL_RPATH:STRING=#{libdir}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{libdir}
      -DVTK_USE_SYSTEM_EXPAT=ON
      -DVTK_USE_SYSTEM_LIBXML2=ON
      -DVTK_USE_SYSTEM_ZLIB=ON
    ]

    args << "-DBUILD_EXAMPLES=" + ((build.with? "examples") ? "ON" : "OFF")

    if build.with? "qt" or build.with? "qt-extern"
      args << "-DVTK_USE_GUISUPPORT=ON"
      args << "-DVTK_USE_QT=ON"
      args << "-DVTK_USE_QVTK=ON"
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


    args << "-DVTK_USE_BOOST=ON" if build.with? "boost"
    args << "-DVTK_USE_SYSTEM_HDF5=ON" if build.with? "hdf5"
    args << "-DVTK_USE_SYSTEM_JPEG=ON" if build.with? "jpeg"
    args << "-DVTK_USE_SYSTEM_PNG=ON" if build.with? "libpng"
    args << "-DVTK_USE_SYSTEM_TIFF=ON" if build.with? "libtiff"
    args << "-DVTK_LEGACY_REMOVE=ON" if build.without? "legacy"

    ENV.cxx11 if build.cxx11?

    mkdir "build" do
      if build.with? "python"
        args << "-DVTK_WRAP_PYTHON=ON"
        # CMake picks up the system's python dylib, even if we have a brewed one.
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
        # Set the prefix for the python bindings to the Cellar
        args << "-DVTK_PYTHON_SETUP_ARGS:STRING='--prefix=#{prefix} --single-version-externally-managed --record=installed.txt'"
        if build.with? "pyqt"
          args << "-DVTK_WRAP_PYTHON_SIP=ON"
          args << "-DSIP_PYQT_DIR="#{HOMEBREW_PREFIX}/share/sip""
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

        VTK5 is keg only in favor of VTK6. Add
            #{opt_prefix}/lib/python2.7/site-packages
        to your PYTHONPATH before using the python bindings.
    EOS

    if build.with? "examples"
      s += <<-EOS.undent

        The scripting examples are stored in #{HOMEBREW_PREFIX}/share/vtk

      EOS
    end
    return s.empty? ? nil : s
  end

end

__END__
diff --git a/Wrapping/Python/setup_install_paths.py b/Wrapping/Python/setup_install_paths.py
index 00f48c8..014b906 100755
--- a/Wrapping/Python/setup_install_paths.py
+++ b/Wrapping/Python/setup_install_paths.py
@@ -35,7 +35,7 @@ def get_install_path(command, *args):
                 option, value = string.split(arg,"=")
                 options[option] = value
             except ValueError:
-                options[option] = 1
+                options[arg] = 1

     # check for the prefix and exec_prefix
     try:

