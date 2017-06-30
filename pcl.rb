require File.expand_path("../Requirements/cuda_requirement", __FILE__)

class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "http://www.pointclouds.org/"
  url "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.8.0.tar.gz"
  sha256 "9e54b0c1b59a67a386b9b0f4acb2d764272ff9a0377b825c4ed5eedf46ebfcf4"
  revision 7

  head "https://github.com/PointCloudLibrary/pcl.git"

  bottle do
    rebuild 1
    sha256 "9b3570db0bc4624a00f793c4ada2409036e1d11626a3d434b576623b02065b00" => :sierra
    sha256 "cb7f4b68a7209677821115abfa1048744a7d526a2687580e99044498d075f4d1" => :el_capitan
    sha256 "222272c78558c7516d3dae002f510c9c225e8a4a50374a66d81643cc08672c19" => :yosemite
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-examples", "Build pcl examples."
  option "without-tools", "Build without tools."
  option "without-apps", "Build without apps."
  option "with-surface_on_nurbs", "Build with surface_on_nurbs."

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "cminpack"

  depends_on "qhull"
  depends_on "libusb"

  depends_on "glew"
  depends_on CudaRequirement => :optional
  depends_on "qt" => :optional

  if build.with? "qt"
    depends_on "sip" # Fix for building system
    depends_on "pyqt5" => ["with-python", "without-python3"] # Fix for building system
    depends_on "vtk" => [:recommended, "with-qt"]
  else
    depends_on "vtk" => :recommended
  end
  depends_on "openni" => :optional
  depends_on "openni2" => :optional
  if OS.linux?
    resource "XML::Parser" do
      url "https://cpan.metacpan.org/CPAN/authors/id/M/MS/MSERGEANT/XML-Parser-2.36.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/M/MS/MSERGEANT/XML-Parser-2.36.tar.gz"
      sha256 "9fd529867402456bd826fe0e5588d35b3a2e27e586a2fd838d1352b71c2ed73f"
    end
  end

  def install
    # Reduce memory usage below 4 GB for Linux CI
    ENV["MAKEFLAGS"] = "-j1" if OS.linux? && build.bottle?

    if OS.linux?
      resource("XML::Parser").stage do
        system "perl", "Makefile.PL", "LIB=#{libexec}/PerlLib", "PREFIX=#{libexec}/vendor"
        system "make", "install"
      end
    end

    args = std_cmake_args + %w[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_simulation:BOOL=AUTO_OFF
      -DBUILD_outofcore:BOOL=AUTO_OFF
      -DBUILD_people:BOOL=AUTO_OFF
      -DBUILD_global_tests:BOOL=OFF
      -DWITH_TUTORIALS:BOOL=OFF
      -DWITH_DOCS:BOOL=OFF
    ]
    if build.with? "qt"
      args << "-DPCL_QT_VERSION=5"
    else
      args << "-DWITH_QT:BOOL=FALSE"
    end

    if build.with? "cuda"
      args += %w[
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
      args += %w[
        -DBUILD_apps=AUTO_OFF
        -DBUILD_apps_3d_rec_framework=AUTO_OFF
        -DBUILD_apps_cloud_composer=AUTO_OFF
        -DBUILD_apps_in_hand_scanner=AUTO_OFF
        -DBUILD_apps_optronic_viewer=AUTO_OFF
        -DBUILD_apps_point_cloud_editor=AUTO_OFF
      ]
      if !build.head? && build.without?("qt")
        args << "-DBUILD_apps_modeler:BOOL=OFF"
      else
        args << "-DBUILD_apps_modeler=AUTO_OFF"
      end
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

    if build.with? "surface_on_nurbs"
      args << "-DBUILD_surface_on_nurbs:BOOL=ON"
    else
      args << "-DBUILD_surface_on_nurbs:BOOL=OFF"
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

  test do
    assert_match "tiff files", shell_output("#{bin}/pcl_tiff2pcd -h", 255)
  end
end
