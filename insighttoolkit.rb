require 'formula'

class Insighttoolkit < Formula
  homepage 'http://www.itk.org'
  url 'http://downloads.sourceforge.net/project/itk/itk/4.4/InsightToolkit-4.4.2.tar.gz'
  sha1 '224b16472442e31512fd99070de6babd242f1d64'

  head 'git://itk.org/ITK.git'

  depends_on 'cmake' => :build
  depends_on 'vtk' => :build
  depends_on :python => :recommended

  option 'examples', 'Compile and install various examples'
  option 'with-opencv-bridge', 'Include OpenCV bridge'
  option 'with-itkv3-compatibility', 'Include ITKv3 compatibility'

  def patches
    # Add a patch for ITK 4.4.2, so it can build with VTK 6.0.0 while ITKVtkGlue is set to ON
    # Needs to be removed for ITK 4.4.3
    # See : https://github.com/Kitware/ITK/commit/f715cc5c431186165480b8f5e3df9f78de9d141f
    DATA unless build.head?
  end

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    args << ".."
    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')
    args << '-DModule_ITKVideoBridgeOpenCV=' + ((build.include? 'with-opencv-bridge') ? 'ON' : 'OFF')
    args << '-DITKV3_COMPATIBILITY:BOOL=' + ((build.include? 'with-itkv3-compatibility') ? 'ON' : 'OFF')

    mkdir 'itk-build' do
      python do
        args = args + %W[
          -DITK_WRAP_PYTHON=ON
          -DModule_ITKVtkGlue=ON
          -DCMAKE_C_FLAGS='-ansi'
        ]
        # Cmake picks up the system's python dylib, even if we have a brewed one.
        args << "-DPYTHON_LIBRARY='#{python.libdir}/lib#{python.xy}.dylib'"
        # The make and make install have to be inside the python do loop
        # because the PYTHONPATH is defined by this block (and not outside)
        system "cmake", *args
        system "make install"
      end
      if not python then  # no python bindings
        system "cmake", *args
        system "make install"
      end
    end
  end
end

__END__
diff --git a/Modules/Bridge/VtkGlue/wrapping/CMakeLists.txt b/Modules/Bridge/VtkGlue/wrapping/CMakeLists.txt
index 71df1b4..c84d1a3 100644
--- a/Modules/Bridge/VtkGlue/wrapping/CMakeLists.txt
+++ b/Modules/Bridge/VtkGlue/wrapping/CMakeLists.txt
@@ -8,5 +8,9 @@ itk_wrap_module(ITKVtkGlue)
 itk_end_wrap_module()

 if(ITK_WRAP_PYTHON)
-  target_link_libraries(ITKVtkGluePython vtkImagingPythonD vtkPythonCore)
+  if(${VTK_VERSION} VERSION_LESS 6.0.0)
+    target_link_libraries(ITKVtkGluePython vtkImagingPythonD vtkPythonCore)
+  else()
+    target_link_libraries(ITKVtkGluePython vtkImagingCorePythonD)
+  endif()
 endif()
--
