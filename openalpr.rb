class Openalpr < Formula
  desc "Automatic License Plate Recognition library"
  homepage "https://github.com/openalpr/openalpr"
  url "https://github.com/openalpr/openalpr/archive/v2.3.0.tar.gz"
  sha256 "1cfcaab6f06e9984186ee19633a949158c0e2aacf9264127e2f86bd97641d6b9"
  head "https://github.com/openalpr/openalpr.git", :branch => "master"

  bottle do
    sha256 "88834bb81c3d4c937f6875223e98e26490854f3310f7ac1524f313c6e9ed3e71" => :el_capitan
    sha256 "962168ab7bf72ed14060f4c36a493251b180332b8c8b4e898dd9b1c3956faa0f" => :yosemite
    sha256 "b4b365cd4d4200b1acc3c388d7ffee809544c05863751751852e23f56ff6d8dd" => :mavericks
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
      args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"

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
    output = shell_output("#{bin}/alpr #{test_fixtures("test.jpg")}")
    assert_equal "No license plates found.", output.chomp
  end
end
