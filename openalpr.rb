class Openalpr < Formula
  homepage "https://www.github.com/openalpr/openalpr"
  url "https://github.com/openalpr/openalpr/archive/v1.2.0.tar.gz"
  sha256 "ff8d7741c84b555d2569dd3ceb524e1d70fbd0b25769c5075079e977609de18d"

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

  stable do
    # newer versions do not depend on ossp-uuid
    depends_on "ossp-uuid"

    # A partial backport of this pull request:
    # https://github.com/openalpr/openalpr/pull/55
    patch :p1 do
      url "https://gist.githubusercontent.com/twelve17/460c57fbe732fd59dc6c/raw/b910f3f47f231408499d34f9e67ccbe96c5f5449/openalpr_1.2_cmakelists.patch"
      sha256 "2718353d0349017f2167cec32b819db4bd76c0827c9346af549dd7b5e7deee5e"
    end
  end

  def install
    mkdir "src/build" do
      args = std_cmake_args

      args << "-DCMAKE_MACOSX_RPATH=true" if build.head?

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
