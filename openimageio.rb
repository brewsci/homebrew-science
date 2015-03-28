require "formula"

class Openimageio < Formula
  homepage "http://openimageio.org"
  url "https://github.com/OpenImageIO/oiio/archive/Release-1.5.13.tar.gz"
  sha256 "ff9fd20eb2ad3a4d05e9e2849f18a62d4fe7a9330de21f177db597562d947429"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "6c83fb520dc611786ae3a04463a278e85051dc773203586b0e2f27fc9752dd5a" => :yosemite
    sha256 "96f85a546724428a655d8fa13fd23b5c3edff414602e81f85317c64e1ae7c5dc" => :mavericks
    sha256 "6317fa951007310d7544f4c185ccbe12db85dfcb0662d229b3f66b0d8b75fcd4" => :mountain_lion
  end

  head "https://github.com/OpenImageIO/oiio.git"

  option "with-tests",  "Dowload 95MB of test images and verify Oiio (~2 min)"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "qt" => :optional # for openimageio viewer
  depends_on "opencolorio"
  depends_on "ilmbase"
  depends_on "openexr"
  depends_on "boost"
  depends_on "boost-python"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "jpeg"
  depends_on "openjpeg"
  depends_on "cfitsio"
  depends_on "hdf5"
  depends_on "field3d"
  depends_on "webp"
  depends_on "glew"
  depends_on "freetype"
  depends_on "openssl"
  depends_on "giflib" => :optional

  # don't link to a specific Python framework
  # https://github.com/OpenImageIO/oiio/pull/1099
  patch :DATA

  resource "j2kp4files" do
    url "http://pkgs.fedoraproject.org/repo/pkgs/openjpeg/j2kp4files_v1_5.zip/27780ed3254e6eb763ebd718a8ccc340/j2kp4files_v1_5.zip"
    sha1 "a90cad94abbe764918175db72b49df6d2f63704b"
  end

  resource "tiffpic" do
    url "ftp://ftp.remotesensing.org/pub/libtiff/pics-3.8.0.tar.gz"
    sha1 "f50e14335fd98f73c6a235d3ff4d83cf4767ab37"
  end

  resource "bmpsuite" do
    url "http://entropymine.com/jason/bmpsuite/bmpsuite.zip"
    sha1 "2e43ec4d8e6f628f71a554c327433914000db7ba"
    version "1.0.0"
  end

  resource "tgautils" do
    url "http://googlesites.inequation.org/TGAUTILS.ZIP?attredirects=0"
    sha1 "0902c51e7b00ae70a460250f60d6adc41c8095df"
    version "1.0.0"
  end

  resource "openexrimages" do
    url "http://download.savannah.nongnu.org/releases/openexr/openexr-images-1.5.0.tar.gz"
    sha1 "22bb1a3d37841a88647045353f732ceac652fd3f"
  end

  resource "oiioimages" do
    url "https://github.com/OpenImageIO/oiio-images/tarball/9bf43561f5"
    sha1 "8f12a86098120fd10ceb294a0d3aa1c95a0d3f80"
    version "1.0.0"
  end

  def install
    # Oiio is designed to have its testsuite images extracted one directory
    # above the source.  That's not a safe place for HB.  Do the opposite,
    # and move the entire source down into a subdirectory if --with-tests.
    if build.with? "tests"
      (buildpath+"localpub").install Dir["*"]
      chdir "localpub"
    end

    ENV.append "MY_CMAKE_FLAGS", "-Wno-dev"   # stops a warning.
    ENV.append "MY_CMAKE_FLAGS", "-DOPENJPEG_INCLUDE_DIR=#{Formula["openjpeg"].opt_include}/openjpeg-1.5"
    ENV.append "MY_CMAKE_FLAGS", "-DFREETYPE_INCLUDE_DIRS=#{Formula["freetype"].opt_include}/freetype2"
    ENV.append "MY_CMAKE_FLAGS", "-DUSE_OPENCV=OFF"
    ENV.append "MY_CMAKE_FLAGS", "-DCMAKE_FIND_FRAMEWORK=LAST"

    args = ["USE_TBB=1", "EMBEDPLUGINS=1"]

    # Download standardized test images if the user throws --with-tests.
    # 90% of the images are in tarballs, so they are cached normally.
    # The webp and fits images are loose.  Curl them each install.
    if build.with? "tests"
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
      resource("openexrimages").stage { (d+"openexr-images-1.5.0").install Dir["*"] }
      resource("oiioimages").stage { (d+"oiio-images").install Dir["*"] }
    end

    # make is a shell wrapper for cmake crafted by the devs (who have Lion).
    args << "USE_OPENGL=" + (build.with?("qt") ? "1" : "0")
    system "make", *args
    system "make", "test" if build.with? "tests"
    cd "dist/macosx" do
      (lib/"python2.7").install "lib/python/site-packages"
      prefix.install  %w[bin include]
      lib.install    Dir["lib/lib*"]
      doc.install    "share/doc/openimageio/openimageio.pdf"
      prefix.install Dir["share/doc/openimageio/*"]
    end
  end

  test do
    system bin/"oiiotool", "--info", test_fixtures("test.jpg")
    system bin/"oiiotool", "--info", test_fixtures("test.png")
  end
end
__END__
diff --git a/src/python/CMakeLists.txt b/src/python/CMakeLists.txt
index ab583d1..038691c 100644
--- a/src/python/CMakeLists.txt
+++ b/src/python/CMakeLists.txt
@@ -84,7 +84,12 @@ if (BOOST_CUSTOM OR Boost_FOUND AND PYTHONLIBS_FOUND)

     include_directories (${PYTHON_INCLUDE_PATH} ${Boost_INCLUDE_DIRS})
     add_library (${target_name} MODULE ${python_srcs})
-    target_link_libraries (${target_name} OpenImageIO ${Boost_LIBRARIES} ${Boost_PYTHON_LIBRARIES} ${PYTHON_LIBRARIES} ${CMAKE_DL_LIBS})
+    if (APPLE)
+        target_link_libraries (${target_name} OpenImageIO ${Boost_LIBRARIES} ${Boost_PYTHON_LIBRARIES} ${CMAKE_DL_LIBS})
+        set_target_properties(${target_name} PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
+    else ()
+        target_link_libraries (${target_name} OpenImageIO ${Boost_LIBRARIES} ${Boost_PYTHON_LIBRARIES} ${PYTHON_LIBRARIES} ${CMAKE_DL_LIBS})
+    endif ()

     # Exclude the 'lib' prefix from the name
     if(NOT PYLIB_LIB_PREFIX)
