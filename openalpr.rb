class Openalpr < Formula
  homepage "https://github.com/openalpr/openalpr"
  url "https://github.com/openalpr/openalpr/archive/v2.2.0.tar.gz"
  sha256 "44258a7b64a74ad773825f37ba0a77e07ee97fdb9cd1f4a45baede624524f20f"

  head "https://github.com/openalpr/openalpr.git", :branch => "master"

  option "without-daemon", "Do not include the alpr daemon (alprd)"

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "tesseract"
  depends_on "opencv"

  if build.with? "daemon"
    depends_on "log4cplus"
    depends_on "beanstalk"
  end

  bottle do
    cellar :any
    sha256 "2f8b651b195094ce021dbb10d9d45b515c9eae5c216f28cbedd8443f8cf67894" => :el_capitan
    sha256 "02fbabd458b2bc003b41ef67ce265e2f3ebc1171c7aa725b4af8be56ff1accbc" => :yosemite
    sha256 "e2ef55298ca2a38d0104c1e683f56ce4acbdc9d51a50d252e9a8f2e9d62e328c" => :mavericks
  end

  def install
    mkdir "src/build" do
      args = std_cmake_args

      # v2.2.0 require CMAKE_MACOSX_RPATH
      args << "-DCMAKE_MACOSX_RPATH=true"
      args << "-DCMAKE_INSTALL_SYSCONFDIR=/usr/local/etc"

      if build.without? "daemon"
        if build.head?
          args << "-DWITH_DAEMON=NO"
        else
          args << "-DWITHOUT_DAEMON=YES"
        end
      end

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    actual = `#{bin}/alpr #{HOMEBREW_PREFIX}/Library/Homebrew/test/fixtures/test.jpg`
    assert_equal "No license plates found.\n", actual, "output from reading test JPG image"
  end
end
