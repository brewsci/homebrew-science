class Gtsam < Formula
  homepage "https://collab.cc.gatech.edu/borg/gtsam/"
  url "https://research.cc.gatech.edu/borg/sites/edu.borg/files/downloads/gtsam-3.2.1.tgz"
  sha256 "1e9217c11d92e6838e2d0bec3a7dd0d36d2131acdf2e50264f6dc225d8ce1a97"

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
