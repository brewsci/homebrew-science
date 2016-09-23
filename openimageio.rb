class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "http://openimageio.org"
  url "https://github.com/OpenImageIO/oiio/archive/Release-1.6.16.tar.gz"
  sha256 "619592ef04e9fd239e86be79d13f67234a3a0f4c60b3906ba1eeebfc28dddc89"
  head "https://github.com/OpenImageIO/oiio.git"

  bottle do
    cellar :any
    sha256 "af0b2bcda297795dca9b908a07aaffd12572a6a244a588df0376b6072d65b871" => :el_capitan
    sha256 "9991b4800b4048284221c8a3a20bcf968f196dfd6224478cfc0cdc455afc8c47" => :yosemite
    sha256 "77a82cb6db1df3381c99041be4af7c7721aeafc984a014f79c9deff87e9f9118" => :mavericks
  end

  option "with-test", "Dowload 95MB of test images and verify Oiio (~2 min)"
  option "with-qt", "Build with qt support, neccessary for iv image viewer"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "qt" => :optional # for openimageio viewer
  depends_on "boost"
  depends_on "openssl"
  depends_on "cfitsio"
  depends_on "field3d"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "hdf5"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "opencv" => :recommended
  depends_on python3: :optional

  depends_on "glew" if build.with? "qt"

  depends_on "boost-python" => (build.with?("python3") ? ["with-python3"] : [])

  resource "j2kp4files" do
    url "http://pkgs.fedoraproject.org/repo/pkgs/openjpeg/j2kp4files_v1_5.zip/27780ed3254e6eb763ebd718a8ccc340/j2kp4files_v1_5.zip"
    sha256 "21cf3156ed2a2a39765c0d57f36c71d1291e9c30054775a2f0a8fdd2964f1799"
  end

  resource "tiffpic" do
    url "ftp://ftp.remotesensing.org/pub/libtiff/pics-3.8.0.tar.gz"
    sha256 "e0e34732b61e1ce49eff2c7a079994c856d2a5f772f5228c84678272bc6829a9"
  end

  resource "bmpsuite" do
    url "http://entropymine.com/jason/bmpsuite/bmpsuite.zip"
    sha256 "7c7643003476da4e2b29ebbb0ed1ca28cf7eb21a04b4f474567c1bea5caba089"
    version "1.0.0"
  end

  resource "tgautils" do
    url "https://github.com/dunn/mirrors/raw/master/openimageio/TGAUTILS.ZIP"
    sha256 "1c05c376800d75332e544b665354b9e234f97352266b4dea40d5424d8bcb3299"
    version "1.0.0"
  end

  resource "openexrimages" do
    url "http://download.savannah.nongnu.org/releases/openexr/openexr-images-1.7.0.tar.gz"
    sha256 "99e3fabef4672f62f4a10a470eea4a161026d488cabc418fff619638deacf807"
  end

  resource "oiioimages" do
    url "https://github.com/OpenImageIO/oiio-images.git",
        revision: "9a70c65c7a29a50114a8208d61c87ba4fedd018e"
  end

  def pyver
    Language::Python.major_minor_version "python"
  end

  def py3ver
    Language::Python.major_minor_version "python3"
  end

  def install
    # Oiio is designed to have its testsuite images extracted one directory
    # above the source.  That's not a safe place for HB.  Do the opposite,
    # and move the entire source down into a subdirectory if --with-test.
    if build.with? "test"
      (buildpath+"localpub").install Dir["*"]
      chdir "localpub"
    end

    # May require a revision bump if the glew version changes
    inreplace "src/cmake/externalpackages.cmake", "GLEW_VERSION 1.5.1", "GLEW_VERSION 2.0.0" if build.with? "qt"

    ENV.append "MY_CMAKE_FLAGS", "-Wno-dev" # stops a warning.
    ENV.append "MY_CMAKE_FLAGS", "-DUSE_OPENCV=OFF" if build.without? "opencv"
    ENV.append "MY_CMAKE_FLAGS", "-DCMAKE_FIND_FRAMEWORK=LAST"
    ENV.append "MY_CMAKE_FLAGS", "-DCMAKE_VERBOSE_MAKEFILE=ON"

    # Explicilty disable CMake modules to prevent undeclared dependencies
    ENV.append "MY_CMAKE_FLAGS", "-DUSE_FFMPEG=OFF"
    ENV.append "MY_CMAKE_FLAGS", "-DUSE_JPEGTURBO=OFF"
    ENV.append "MY_CMAKE_FLAGS", "-DUSE_LIBRAW=OFF"
    ENV.append "MY_CMAKE_FLAGS", "-DUSE_PTEX=OFF"

    # CMake picks up the system's python dylib, even if we have a brewed one.
    # Code taken from the Insighttoolkit formula
    if build.with? "python3"
      ENV["PYTHONPATH"] = lib/"python#{py3ver}/site-packages"
      ENV.append "MY_CMAKE_FLAGS", "-DPYTHON_EXECUTABLE='#{`python3-config --prefix`.chomp}/bin/python3'"
      ENV.append "MY_CMAKE_FLAGS", "-DPYTHON_LIBRARY='#{`python3-config --prefix`.chomp}/lib/libpython#{py3ver}.dylib'"
      ENV.append "MY_CMAKE_FLAGS", "-DPYTHON_INCLUDE_DIR='#{`python3-config --prefix`.chomp}/include/python#{py3ver}m'"
    end

    args = ["EMBEDPLUGINS=1"]

    # Download standardized test images if the user throws --with-test.
    # 90% of the images are in tarballs, so they are cached normally.
    # The webp and fits images are loose.  Curl them each install.
    if build.with? "test"
      d = buildpath

      mkdir d+"webp-images" do
        curl "http://www.gstatic.com/webp/gallery/[1-5].webp", "-O"
      end
      mkdir d+"fits-images"
      mkdir d+"fits-images/pg93" do
        curl "http://www.cv.nrao.edu/fits/data/tests/pg93/tst000[1-3].fits", "-O"
        curl "http://www.cv.nrao.edu/fits/data/tests/pg93/tst000[5-9].fits", "-O"
        curl "http://www.cv.nrao.edu/fits/data/tests/pg93/tst0013.fits", "-O"
      end
      mkdir d+"fits-images/ftt4b" do
        curl "http://www.cv.nrao.edu/fits/data/tests/ftt4b/file00[1-3].fits", "-O"
        curl "http://www.cv.nrao.edu/fits/data/tests/ftt4b/file0{09,12}.fits", "-O"
      end

      resource("j2kp4files").stage { (d+"j2kp4files_v1_5").install Dir["J2KP4files/*"] }
      resource("tiffpic").stage { (d+"libtiffpic").install Dir["*"] }
      resource("bmpsuite").stage { (d+"bmpsuite").install Dir["*"] }
      resource("tgautils").stage { (d+"TGAUTILS").install Dir["*"] }
      resource("openexrimages").stage { (d+"openexr-images").install Dir["*"] }
      resource("oiioimages").stage { (d+"oiio-images").install Dir["*"] }
    end

    if build.with? "qt"
      args << "USE_OPENGL=ON"
      args << "USE_QT=ON"
    else
      args << "USE_OPENGL=OFF"
      args << "USE_QT=OFF"
    end

    args << "USE_PYTHON3=ON" if build.with? "python3"

    system "make", *args
    system "make", "test" if build.with? "test"
    cd "dist/macosx" do
      (lib/"python#{pyver}").install "python"
      (lib/"python#{py3ver}").install "python3" if build.with? "python3"
      prefix.install %w[bin include]
      lib.install Dir["lib/lib*"]
      doc.install "doc/openimageio.pdf"
      prefix.install Dir["doc/*"]
    end
  end

  test do
    system bin/"oiiotool", "--info", test_fixtures("test.jpg")
    system bin/"oiiotool", "--info", test_fixtures("test.png")
  end
end
