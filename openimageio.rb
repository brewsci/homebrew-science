require "formula"

class Openimageio < Formula
  homepage "http://openimageio.org"
  url "https://github.com/OpenImageIO/oiio/archive/Release-1.4.8.tar.gz"
  sha1 "412793b71ba5510709795a47395a78436a4c5344"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "e8877d136f53b979d6475ffdb1dc2a6d7ec83ca3" => :yosemite
    sha1 "7de4b327278ab20402da67a67c5b7aea02dbc36f" => :mavericks
    sha1 "9c61260679b66d7f45818720dfaa06764d58e9ae" => :mountain_lion
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
  depends_on "libtiff"
  depends_on "jpeg"
  depends_on "openjpeg"
  depends_on "cfitsio"
  depends_on "hdf5" => "with-cxx"
  depends_on "field3d"
  depends_on "webp"
  depends_on "glew"
  depends_on "freetype"
  depends_on "openssl"

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
    url "http://makseq.com/materials/lib/Code/FileFormats/BitMap/TARGA/TGAUTILS.ZIP"
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

    args = ["USE_TBB=1", "EMBEDPLUGINS=1"]

    python_prefix = `python-config --prefix`.strip
    # Python is actually a library. The libpythonX.Y.dylib points to this lib, too.
    if File.exist? "#{python_prefix}/Python"
      # Python was compiled with --framework:
      ENV.append "MY_CMAKE_FLAGS", "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
      ENV.append "MY_CMAKE_FLAGS", "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
    else
      python_version = `python-config --libs`.match("-lpython(\d+\.\d+)").captures.at(0)
      python_lib = "#{python_prefix}/lib/libpython#{python_version}"
      ENV.append "MY_CMAKE_FLAGS", "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/python#{python_version}'"
      if File.exist? "#{python_lib}.a"
        ENV.append "MY_CMAKE_FLAGS", "-DPYTHON_LIBRARY='#{python_lib}.a'"
      else
        ENV.append "MY_CMAKE_FLAGS", "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
      end
    end

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
    # There is no working make install in 1.1.6, devel or HEAD.
    cd "dist/macosx" do
      (lib + which_python ).install "lib/python/site-packages"
      prefix.install  %w[bin include]
      lib.install    Dir["lib/lib*"]
      doc.install    "share/doc/openimageio/openimageio.pdf"
      prefix.install Dir["share/doc/openimageio/*"]
    end
  end

  def caveats; <<-EOS.undent
    If OpenImageIO is brewed using non-homebrew Python, then you need to amend
    your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
