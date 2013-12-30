require 'formula'

class Insighttoolkit < Formula
  homepage 'http://www.itk.org'
  url 'http://downloads.sourceforge.net/project/itk/itk/4.5/InsightToolkit-4.5.0.tar.gz'
  sha1 '64a01e9464b6bd298ec218420967301590501dc2'

  head 'git://itk.org/ITK.git'

  depends_on 'cmake' => :build
  depends_on 'vtk' => :build
  depends_on 'opencv' => :optional
  depends_on :python => :optional

  option 'examples', 'Compile and install various examples'
  option 'with-itkv3-compatibility', 'Include ITKv3 compatibility'

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    args << ".."
    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')
    args << '-DModule_ITKVideoBridgeOpenCV=' + ((build.with? 'opencv') ? 'ON' : 'OFF')
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
