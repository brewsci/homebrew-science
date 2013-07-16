require 'formula'

class Insighttoolkit < Formula
  homepage 'http://www.itk.org'
  url 'http://downloads.sourceforge.net/project/itk/itk/4.3/InsightToolkit-4.3.2.tar.gz'
  sha1 '1c8ff03a92fd9c67e58fdfa704b95a10d3ed4c97'

  head 'git://itk.org/ITK.git'

  option 'examples', 'Compile and install various examples'
  option 'with-opencv-bridge', 'Include OpenCV bridge'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    args << ".."
    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')
    args << '-DModule_ITKVideoBridgeOpenCV=' + ((build.include? 'with-opencv-bridge') ? 'ON' : 'OFF')

    mkdir 'itk-build' do
      system "cmake", *args
      system "make install"
    end
  end
end
