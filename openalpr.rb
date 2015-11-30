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
    sha256 "ab144e27d4d0456b938169ca16590a2ac72b477dff6de05eb02220c431f19b49" => :yosemite
    sha256 "40878f54d0fd1eeb1c2ea07534b52b6c782a5cc3a3223add2453ed7bfc4f9bd7" => :mavericks
    sha256 "3a311bd4c4ac6fd12ad981289f9c4299eff01b156ead0dcece4109af4e86547e" => :mountain_lion
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
