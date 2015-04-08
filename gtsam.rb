class Gtsam < Formula
  homepage "https://collab.cc.gatech.edu/borg/gtsam/"
  url "https://research.cc.gatech.edu/borg/sites/edu.borg/files/downloads/gtsam-3.2.1.tgz"
  sha256 "1e9217c11d92e6838e2d0bec3a7dd0d36d2131acdf2e50264f6dc225d8ce1a97"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "5e1040d1a55f395b038e5ee5647377a2b8182f2af0536f8e8c028c81cc7f57d9" => :yosemite
    sha256 "b62f92c94589f4794cfe67076213aeae26234a464aa87727e2312da32c277eb4" => :mavericks
    sha256 "4c9a630f008d37f1ecd19cd1ce87912206f2eed24caf0c7b6404b5c08eba74cf" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "boost"

  option "with-tests", "Run unit tests at build-time"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "check" if build.with? "tests"
      system "make", "install"
    end
  end

  test do
    system bin/"wrap"
  end
end
