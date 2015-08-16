class Openalpr < Formula
  desc "Automatic License Plate Recognition library"
  homepage "https://github.com/openalpr/openalpr"
  url "https://github.com/openalpr/openalpr/archive/v2.2.0.tar.gz"
  sha256 "44258a7b64a74ad773825f37ba0a77e07ee97fdb9cd1f4a45baede624524f20f"
  revision 1

  head "https://github.com/openalpr/openalpr.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "2f1efd5e26f992939b6faaba2c7591febdd32fc0973211833801990f28817c20" => :el_capitan
    sha256 "737402a2754107aa569656f48d53669b8063240d1481018f0002512f8de67d73" => :yosemite
    sha256 "ecb2aa8c6607074a736c21bd55990041860e59b2ed0f1c040484cf6a813807a2" => :mavericks
  end

  option "without-daemon", "Do not include the alpr daemon (alprd)"

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "leptonica"
  depends_on "libtiff"
  depends_on "tesseract"
  depends_on "opencv"

  if build.with? "daemon"
    depends_on "log4cplus"
    depends_on "beanstalkd"
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

      args << "-DCMAKE_INSTALL_SYSCONFDIR:PATH=#{etc}"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    actual = `#{bin}/alpr #{HOMEBREW_PREFIX}/Library/Homebrew/test/fixtures/test.jpg`
    assert_equal "No license plates found.\n", actual, "output from reading test JPG image"
  end
end
