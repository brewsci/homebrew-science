class Gtsam < Formula
  desc "Library of C++ classes that implement SAM in robotics and vision"
  homepage "https://bitbucket.org/gtborg/gtsam/"
  revision 2

  stable do
    url "https://research.cc.gatech.edu/borg/sites/edu.borg/files/downloads/gtsam-3.2.1.tgz"
    sha256 "1e9217c11d92e6838e2d0bec3a7dd0d36d2131acdf2e50264f6dc225d8ce1a97"

    depends_on "homebrew/versions/boost157"
  end

  bottle do
    cellar :any
    sha256 "afaafae9dcfbaea2f6a1e209c7c3175fc37dea20cf80f33295ac9e83aea5e3fe" => :el_capitan
    sha256 "6f778010469b78ad3fc91950ea29207465bc9a9a9fd94a34c0e6ca71794e2b4c" => :yosemite
    sha256 "591a5d5c40b2561382131b5ab00707a468c813f259e5b2dfff89e605f61175d4" => :mavericks
  end

  head do
    url "https://bitbucket.org/gtborg/gtsam.git"

    depends_on "homebrew/versions/boost159"
  end

  option "without-test", "Run unit tests at build-time"

  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "check" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    system bin/"wrap"
  end
end
