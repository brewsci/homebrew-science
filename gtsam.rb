class Gtsam < Formula
  desc "Library of C++ classes that implement SAM in robotics and vision"
  homepage "https://bitbucket.org/gtborg/gtsam/"
  revision 3

  stable do
    url "https://research.cc.gatech.edu/borg/sites/edu.borg/files/downloads/gtsam-3.2.1.tgz"
    sha256 "1e9217c11d92e6838e2d0bec3a7dd0d36d2131acdf2e50264f6dc225d8ce1a97"

    depends_on "boost@1.57"
  end

  bottle do
    cellar :any
    sha256 "d809f1c070f1b326e2279406e20eaf27b3199e606f30222a7b9515a9c5cd7691" => :sierra
    sha256 "5790db55fcabe88b8817e89b5585bda3b271f38f949caee5162cf1b297716952" => :el_capitan
    sha256 "17705911a2080389e8889fcf511c6671e5025fcfe8c963f657f5e9b334bec5d4" => :yosemite
  end

  head do
    url "https://bitbucket.org/gtborg/gtsam.git"

    depends_on "boost@1.59"
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
