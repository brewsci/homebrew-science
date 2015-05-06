class Openimageio < Formula
  homepage "http://openimageio.org"
  url "https://github.com/OpenImageIO/oiio/archive/Release-1.5.14.tar.gz"
  sha256 "b9553fe616c94b872b1e17d1a74d450cdcaf1ad512905253e7d02683dfaa9d63"

  head "https://github.com/OpenImageIO/oiio.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "4e839b3d37e7f2b914320eece4b772defae9648c7ac18ff4b8389e290792378c" => :yosemite
    sha256 "528a7ea11bdb226f870ab10748440db205ee29164b034bc1247a0979449205aa" => :mavericks
    sha256 "55b87460a6f13124bbe033604e3b2a9c2bace62a8bb2fa49ecad1445563d308f" => :mountain_lion
  end

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
    url "http://googlesites.inequation.org/TGAUTILS.ZIP?attredirects=0"
    sha256 "1c05c376800d75332e544b665354b9e234f97352266b4dea40d5424d8bcb3299"
    version "1.0.0"
  end

  resource "openexrimages" do
    url "http://download.savannah.nongnu.org/releases/openexr/openexr-images-1.5.0.tar.gz"
    sha256 "1b3ab7a4e38c6b0085ad3c08fb5463163c2a516e55606bb1b7749648b83fa0d9"
  end

  resource "oiioimages" do
    url "https://github.com/OpenImageIO/oiio-images.git",
        :revision => "9bf43561f5d0f9d23a7b242fdc5849d6afd52ef5"
  end

  def install
    # Oiio is designed to have its testsuite images extracted one directory
    # above the source.  That's not a safe place for HB.  Do the opposite,
    # and move the entire source down into a subdirectory if --with-tests.
    if build.with? "tests"
      (buildpath+"localpub").install Dir["*"]
      chdir "localpub"
    end

    ENV.append "MY_CMAKE_FLAGS", "-Wno-dev" # stops a warning.
    ENV.append "MY_CMAKE_FLAGS", "-DOPENJPEG_INCLUDE_DIR=#{Formula["openjpeg"].opt_include}/openjpeg-1.5"
    ENV.append "MY_CMAKE_FLAGS", "-DFREETYPE_INCLUDE_DIRS=#{Formula["freetype"].opt_include}/freetype2"
    ENV.append "MY_CMAKE_FLAGS", "-DUSE_OPENCV=OFF"
    ENV.append "MY_CMAKE_FLAGS", "-DCMAKE_FIND_FRAMEWORK=LAST"
    ENV.append "MY_CMAKE_FLAGS", "-DCMAKE_VERBOSE_MAKEFILE=ON"

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
      prefix.install %w[bin include]
      lib.install Dir["lib/lib*"]
      doc.install "share/doc/openimageio/openimageio.pdf"
      prefix.install Dir["share/doc/openimageio/*"]
    end
  end

  test do
    system bin/"oiiotool", "--info", test_fixtures("test.jpg")
    system bin/"oiiotool", "--info", test_fixtures("test.png")
  end
end
