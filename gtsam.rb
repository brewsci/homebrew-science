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
    sha256 "546a54313aad31fddb4eaa1bf80a966fa89f6483f85cb1d606e5f0a054cd688d" => :sierra
    sha256 "7c5907a4b57879ddc140ff7850ede98a535f21796eeff0bf0bd73bd0785ce02c" => :el_capitan
    sha256 "b2a280029778cad66e92b2a580fc68c893892923a7768bac53ef1c854a691ab3" => :yosemite
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
