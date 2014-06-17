require 'formula'

class Elemental < Formula
  homepage "http://libelemental.org/"
  url "http://libelemental.org/pub/releases/Elemental-0.84-p1.tgz"
  sha1 "ddbc22f73125570c56c21c6c1191c7f7427d2173"
  head "https://github.com/elemental/Elemental.git"

  option "without-check", "Skip build time tests (not recommended)"
  option "with-qt5", "Build with Qt5 (used for matrix visualizations)"

  depends_on "cmake" => :build
  depends_on :mpi => [:cc, :cxx, :f90]
  depends_on "qt5" => :optional

  needs :cxx11

  def install
    # Override std_cmake_args; CMAKE_BUILD_TYPE must be one of
    # [Hybrid, Pure][Debug, Release]
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=PureRelease",
            "-DCMAKE_FIND_FRAMEWORK=LAST",
            "-DCMAKE_VERBOSE_MAKEFILE=ON",
            "-Wno-dev"]

    # Elemental changes flags between 0.84-p1 & 0.85-dev (HEAD)
    el = build.head? ? "EL" : "ELEM"

    # Bundle tests & examples together for check because examples directory
    # includes code that exercises Qt5 functionality (via spy plots)
    args += ["-D#{el}_TESTS=ON", "-D#{el}_EXAMPLES=ON"] if build.with? "check"
    args << "-D#{el}_USE_QT5=ON" if build.with? "qt5"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"

      if build.with? "check"
        # If running in tmux with Qt5, get the error:
        # PasteBoard: Error creating pasteboard: com.apple.pasteboard.clipboard [-4960]
        # Seems to be a known issue with Qt running in tmux; see
        # https://github.com/ipython/ipython/issues/958.
        # To be safe, also mention other terminal multiplexers.
        opoo "Qt5 tests may return errors if run in tmux or GNU Screen" if build.with? "qt5"

        # Basic smoke test of build for now
        system "mpiexec -np 2 bin/tests/core/AxpyInterface"
        # Qt5 test; if enabled, spy plot of matrix will be made; otherwise,
        # test merely runs without producing spy plot
        system "mpiexec -np 2 bin/examples/matrices/Legendre"
      end

      system "make", "install"
    end
  end

end
