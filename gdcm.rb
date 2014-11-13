require "formula"

class Gdcm < Formula
  homepage "http://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.4.4/gdcm-2.4.4.tar.bz2"
  sha1 "4b77a857cf8432da72140a5e7d20f78c091ee019"

  option "with-check", "Run the GDCM test suite"

  option :cxx11
  cxx11dep = (build.cxx11?) ? ['c++11'] : []

  depends_on "cmake" => :build
  depends_on "vtk" => [:optional] + cxx11dep

  def install
    sourcedir = "#{pwd}/source_files"
    builddir = "#{pwd}/build_files"

    targets = Dir.glob("*")

    mkdir sourcedir
    targets.each do |target|
      mv target, File.join(sourcedir, File.basename(target))
    end
    mkdir builddir do
      args = std_cmake_args
      args << "-DGDCM_BUILD_APPLICATIONS=ON"
      args << "-DGDCM_BUILD_EXAMPLES=ON"
      args << "-DGDCM_BUILD_SHARED_LIBS=ON"
      args << "-DGDCM_BUILD_TESTING=ON" if build.with? "check"
      args << "-DGDCM_USE_VTK=ON" if build.with? "vtk"
      args << sourcedir

      system "cmake", *args

      system "make"
      system "make", "test" if build.with? "check"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gdcminfo", "--version"
  end
end
