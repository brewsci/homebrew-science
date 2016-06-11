class Openalpr < Formula
  desc "Automatic License Plate Recognition library"
  homepage "https://github.com/openalpr/openalpr"
  url "https://github.com/openalpr/openalpr/archive/v2.2.0.tar.gz"
  sha256 "44258a7b64a74ad773825f37ba0a77e07ee97fdb9cd1f4a45baede624524f20f"
  revision 1

  head "https://github.com/openalpr/openalpr.git", :branch => "master"

  bottle do
    cellar :any
    revision 1
    sha256 "5e0af8c162176b5d4fe2ce344f4b7189f574089668085683c11c698fc9c16994" => :el_capitan
    sha256 "bd18915d4c6bf5c24b38628694887b93a56040d6ccb5bdb71070f0e4229feb91" => :yosemite
    sha256 "9546d90b5d3aaf22541651f521b3cabd8a4abe428de117c50135b2b248b4e7c3" => :mavericks
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
