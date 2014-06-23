require "formula"

class Gdcm < Formula
  homepage "http://sourceforge.net/projects/gdcm/"
  url "http://softlayer-dal.dl.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.4.2/gdcm-2.4.2.tar.bz2"
  sha1 "57251e6bdec2654df20039046c15f041c2a71035"

  option "with-check", "Run the GDCM test suite"

  depends_on "cmake" => :build

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
