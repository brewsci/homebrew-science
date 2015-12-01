class CudaRequirement < Requirement
  build true
  fatal true

  satisfy { which "nvcc" }

  env do
    # Nvidia CUDA installs (externally) into this dir (hard-coded):
    ENV.append "CFLAGS", "-F/Library/Frameworks"
    # # because nvcc has to be used
    ENV.append "PATH", which("nvcc").dirname, ":"
  end

  def message
    <<-EOS.undent
      To use this formula with NVIDIA graphics cards you will need to
      download and install the CUDA drivers and tools from nvidia.com.

          https://developer.nvidia.com/cuda-downloads

      Select "Mac OS" as the Operating System and then select the
      'Developer Drivers for MacOS' package.
      You will also need to download and install the 'CUDA Toolkit' package.

      The `nvcc` has to be in your PATH then (which is normally the case).

    EOS
  end
end

class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "http://www.pointclouds.org/"
  url "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.7.2.tar.gz"
  sha256 "479f84f2c658a6319b78271111251b4c2d6cf07643421b66bbc351d9bed0ae93"

  stable do
    patch do
      url "https://gist.githubusercontent.com/fran6co/a6e1e44b1b43b2d150cd/raw/0c4aeb301ed523c81cd57c63b0a9804d49af9848/boost.patch"
      sha256 "5409b0899f65d918248a8fdfb820478cc0b191c50339e16692a911fab76c3f43"
    end
    # Fixes PCL for VTK 6.2.0
    patch do
      url "https://patch-diff.githubusercontent.com/raw/PointCloudLibrary/pcl/pull/1205.patch"
      sha256 "5b7051bb1e9f6f23364fe64221cf96980750a300695b5787860013786438e88c"
    end
  end

  bottle do
    revision 2
    sha256 "a230eba811e4a97b10fdabac6335156a57991aa1ae2c6c1e76836a15af1a9e52" => :el_capitan
    sha256 "7a3a3c83aa71a9a66db30d337a1d6e8388ee5ad2bbfebaca0638ad858bd122a9" => :yosemite
    sha256 "bbd411756ebeac0c48f0b148503255444e6520fdb8ecacc92bf4ccdadd8f21eb" => :mavericks
  end

  head do
    url "https://github.com/PointCloudLibrary/pcl.git"
  end

  option "with-examples", "Build pcl examples."
  option "without-tools", "Build without tools."
  option "without-apps", "Build without apps."

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "cminpack"

  depends_on "qhull"
  depends_on "libusb"

  if build.head?
    depends_on "glew"
    depends_on CudaRequirement => :optional
    depends_on "qt" => :optional
    depends_on "qt5" => :optional
  else
    depends_on "qt" => :recommended
  end

  if build.with? "qt"
    depends_on "sip" # Fix for building system
    depends_on "pyqt" # Fix for building system
    depends_on "vtk" => [:recommended, "with-qt"]
  elsif build.with? "qt5"
    depends_on "sip" # Fix for building system
    depends_on "pyqt5" => ["with-python", "without-python3"] # Fix for building system
    depends_on "vtk" => [:recommended, "with-qt5"]
  else
    depends_on "vtk" => :recommended
  end
  depends_on "openni" => :optional
  depends_on "openni2" => :optional

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_simulation:BOOL=AUTO_OFF
      -DBUILD_outofcore:BOOL=AUTO_OFF
      -DBUILD_people:BOOL=AUTO_OFF
      -DBUILD_global_tests:BOOL=OFF
      -DWITH_TUTORIALS:BOOL=OFF
      -DWITH_DOCS:BOOL=OFF
    ]
    if build.with? "qt"
      args << "-DPCL_QT_VERSION=4"
    elsif build.with? "qt5"
      args << "-DPCL_QT_VERSION=5"
    else
      args << "-DWITH_QT:BOOL=FALSE"
    end

    if build.with? "cuda"
      args += %W[
        -DWITH_CUDA:BOOL=AUTO_OFF
        -DBUILD_GPU:BOOL=ON
        -DBUILD_gpu_people:BOOL=ON
        -DBUILD_gpu_surface:BOOL=ON
        -DBUILD_gpu_tracking:BOOL=ON
      ]
    else
      args << "-DWITH_CUDA:BOOL=OFF"
    end

    if build.with? "openni2"
      ENV.append "OPENNI2_INCLUDE", "#{Formula["openni2"].opt_include}/ni2"
      ENV.append "OPENNI2_LIB", "#{Formula["openni2"].opt_lib}/ni2"
      args << "-DBUILD_OPENNI2:BOOL=ON"
    end

    if build.with? "apps"
      args += %W[
        -DBUILD_apps=AUTO_OFF
        -DBUILD_apps_3d_rec_framework=AUTO_OFF
        -DBUILD_apps_cloud_composer=AUTO_OFF
        -DBUILD_apps_in_hand_scanner=AUTO_OFF
        -DBUILD_apps_modeler=AUTO_OFF
        -DBUILD_apps_optronic_viewer=AUTO_OFF
        -DBUILD_apps_point_cloud_editor=AUTO_OFF
      ]
    else
      args << "-DBUILD_apps:BOOL=OFF"
    end

    args << "-DBUILD_tools:BOOL=OFF" if build.without? "tools"

    if build.with? "examples"
      args << "-DBUILD_examples:BOOL=ON"
    else
      args << "-DBUILD_examples:BOOL=OFF"
    end

    if build.with? "openni"
      args << "-DOPENNI_INCLUDE_DIR=#{Formula["openni"].opt_include}/ni"
    else
      args << "-DCMAKE_DISABLE_FIND_PACKAGE_OpenNI:BOOL=TRUE"
    end

    args << "-DCMAKE_DISABLE_FIND_PACKAGE_VTK:BOOL=TRUE" if build.without? "vtk"

    args << ".."
    mkdir "macbuild" do
      system "cmake", *args
      system "make"
      system "make", "install"

      prefix.install Dir["#{bin}/*.app"]
    end
  end
end
