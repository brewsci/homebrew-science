class Osgearth < Formula
  homepage "http://osgearth.org"
  desc "a geospatial SDK and terrain engine for OpenSceneGraph applications."
  url "https://github.com/gwaldron/osgearth/archive/osgearth-2.6.tar.gz"
  sha256 "965c93837520ab9538038843ff83ee1903548f8be191ee211e40abb0e6c1bb4a"

  head "https://github.com/gwaldron/osgearth.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "718111c4b402b589d0820bc4b8333847c63143ece2758e77d873d5f4c41d7d07" => :yosemite
    sha256 "db863191db807f40851b49f6d2cb0c5c77c70f4c91848d997f244ce9d60b156a" => :mavericks
  end

  option "without-minizip", "Build without Google KMZ file access support"
  option "with-v8", "Build with Google's V8 JavaScript engine support"
  option "with-tinyxml", "Use external libtinyxml, instead of internal"
  option "with-docs-examples", "Build and install html documentation and examples"

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "sqlite"
  depends_on "qt" => :recommended
  depends_on "open-scene-graph" => (build.with? "qt") ? ["with-qt"] : []
  depends_on "minizip" => :recommended
  depends_on "v8" => :optional
  depends_on "tinyxml" => :optional
  depends_on MinimumMacOSRequirement => :mavericks

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.1.tar.gz"
    sha256 "182e5c81c3250e1752e744b6a35af4ef680bb6251276b49ef7d17f1d25e9ce70"
  end

  # fixes support for latest osg release 3.3.3
  # based on https://github.com/gwaldron/osgearth/commit/48264aebc7b01f46de05c5a63b8466aafbda5098
  patch :DATA

  def install
    if (build.with? "docs-examples") && (!which("sphinx-build"))
      # temporarily vendor a local sphinx install
      sphinx_dir = prefix/"sphinx"
      sphinx_site = sphinx_dir/"lib/python2.7/site-packages"
      sphinx_site.mkpath
      ENV.prepend_create_path "PYTHONPATH", sphinx_site
      resource("sphinx").stage { quiet_system "python2.7", "setup.py", "install", "--prefix=#{sphinx_dir}" }
      ENV.prepend_path "PATH", sphinx_dir/"bin"
    end

    args = std_cmake_args
    if MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_64_bit}"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
    end

    args << "-DOSGEARTH_USE_QT=OFF" if build.without? "qt"
    args << "-DWITH_EXTERNAL_TINYXML=ON" if build.with? "tinyxml"

    # v8 and minizip options should have empty values if not defined '--with'
    if build.without? "v8"
      args << "-DV8_INCLUDE_DIR=''" << "-DV8_BASE_LIBRARY=''" << "-DV8_SNAPSHOT_LIBRARY=''"
      args << "-DV8_ICUI18N_LIBRARY=''" << "-DV8_ICUUC_LIBRARY=''"
    end
    # define libminizip paths (skips the only pkconfig dependency in cmake modules)
    mzo = Formula["minizip"].opt_prefix
    args << "-DMINIZIP_INCLUDE_DIR=#{(build.with? "minizip") ? mzo/"include/minizip" : "''"}"
    args << "-DMINIZIP_LIBRARY=#{(build.with? "minizip") ? mzo/"lib/libminizip.dylib" : "''"}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    if build.with? "docs-examples"
      cd "docs" do
        system "make", "html"
        doc.install "build/html" => "html"
      end
      doc.install "data"
      doc.install "tests" => "examples"
      rm_r prefix/"sphinx" if File.exist?(prefix/"sphinx")
    end
  end

  def caveats
    osg = Formula["open-scene-graph"]
    osgver = (osg.linked_keg.exist?) ? osg.version : "#.#.# (version)"
    <<-EOS.undent
    This formula installs Open Scene Graph plugins. To ensure access when using
    the osgEarth toolset, set the OSG_LIBRARY_PATH enviroment variable to:

      #{HOMEBREW_PREFIX}/lib/osgPlugins-#{osgver}

    EOS
  end

  test do
    system "#{bin}/osgearth_version"
  end
end
__END__
diff --git a/src/osgEarth/Capabilities.cpp b/src/osgEarth/Capabilities.cpp
index f8f2f12..2252192 100644
--- a/src/osgEarth/Capabilities.cpp
+++ b/src/osgEarth/Capabilities.cpp
@@ -171,7 +171,11 @@ _supportsRGTC           ( false )
         }
         else
         {
-            _supportsGLSL = GL2->isGlslSupported();
+#if OSG_MIN_VERSION_REQUIRED(3,3,3)
+            _supportsGLSL = GL2->isGlslSupported;
+#else
+			_supportsGLSL = GL2->isGlslSupported();
+#endif
         }

         OE_INFO << LC << "Detected hardware capabilities:" << std::endl;
@@ -230,7 +234,11 @@ _supportsRGTC           ( false )

         if ( _supportsGLSL )
         {
+#if OSG_MIN_VERSION_REQUIRED(3,3,3)
+			_GLSLversion = GL2->glslLanguageVersion;
+#else
             _GLSLversion = GL2->getLanguageVersion();
+#endif
             OE_INFO << LC << "  GLSL Version = " << getGLSLVersionInt() << std::endl;
         }

diff --git a/src/osgEarth/SparseTexture2DArray.cpp b/src/osgEarth/SparseTexture2DArray.cpp
index 272951f..e3c53b6 100644
--- a/src/osgEarth/SparseTexture2DArray.cpp
+++ b/src/osgEarth/SparseTexture2DArray.cpp
@@ -17,6 +17,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>
  */
 #include <osgEarth/SparseTexture2DArray>
+#include <osg/GLExtensions>

 // this class is only supported in newer OSG versions.
 #if OSG_VERSION_GREATER_OR_EQUAL( 2, 9, 8 )
@@ -60,10 +61,18 @@ SparseTexture2DArray::apply( osg::State& state ) const
     //ElapsedTime elapsedTime(&(tom->getApplyTime()));
     tom->getNumberApplied()++;

-    const Extensions* extensions = getExtensions(contextID,true);
+#if OSG_MIN_VERSION_REQUIRED(3,3,3)
+    const osg::GLExtensions* extensions = osg::GLExtensions::Get(contextID,true);
+	bool texture2DArraySupported = extensions->isTexture2DArraySupported;
+	bool texture3DSupported = extensions->isTexture3DSupported;
+#else
+	const Extensions* extensions = getExtensions(contextID,true);
+	bool texture2DArraySupported = extensions->isTexture2DArraySupported();
+	bool texture3DSupported = extensions->isTexture3DSupported();
+#endif

     // if not supported, then return
-    if (!extensions->isTexture2DArraySupported() || !extensions->isTexture3DSupported())
+    if (!texture2DArraySupported || !texture3DSupported)
     {
         OSG_WARN<<"Warning: Texture2DArray::apply(..) failed, 2D texture arrays are not support by OpenGL driver."<<std::endl;
         return;
@@ -191,10 +200,16 @@ SparseTexture2DArray::apply( osg::State& state ) const
             }
         }

-        const Texture::Extensions* texExtensions = Texture::getExtensions(contextID,true);
+#if OSG_MIN_VERSION_REQUIRED(3,3,3)
+        const osg::GLExtensions* texExtensions = osg::GLExtensions::Get(contextID,true);
+		bool generateMipMapSupported = texExtensions->isGenerateMipMapSupported;
+#else
+		const Texture::Extensions* texExtensions = Texture::getExtensions(contextID,true);
+		bool generateMipMapSupported = texExtensions->isGenerateMipMapSupported();
+#endif
         // source images have no mipmamps but we could generate them...
         if( _min_filter != LINEAR && _min_filter != NEAREST && !firstImage->isMipmap() &&
-            _useHardwareMipMapGeneration && texExtensions->isGenerateMipMapSupported() )
+            _useHardwareMipMapGeneration && generateMipMapSupported  )
         {
             _numMipmapLevels = osg::Image::computeNumberOfMipmapLevels( _textureWidth, _textureHeight );
             generateMipmap( state );
@@ -262,8 +277,22 @@ SparseTexture2DArray::applyTexImage2DArray_subload(osg::State& state, osg::Image
     // get the contextID (user defined ID of 0 upwards) for the
     // current OpenGL context.
     const unsigned int contextID = state.getContextID();
+#if OSG_MIN_VERSION_REQUIRED(3,3,3)
+	const osg::GLExtensions* extensions = osg::GLExtensions::Get(contextID,true);
+	unsigned int maxLayerCount = extensions->maxLayerCount;
+	unsigned int max2DSize = extensions->max2DSize;
+	bool generateMipMapSupported = extensions->isGenerateMipMapSupported;
+	bool isNonPowerOfTwoTextureSupported = extensions->isNonPowerOfTwoTextureSupported(_min_filter);
+#else
     const Extensions* extensions = getExtensions(contextID,true);
     const Texture::Extensions* texExtensions = Texture::getExtensions(contextID,true);
+	unsigned int maxLayerCount = extensions->maxLayerCount();
+	unsigned int max2DSize = extensions->max2DSize();
+	bool generateMipMapSupported = texExtensions->isGenerateMipMapSupported();
+	bool isNonPowerOfTwoTextureSupported = texExtensions->isNonPowerOfTwoTextureSupported(_min_filter);
+#endif
+
+
     GLenum target = GL_TEXTURE_2D_ARRAY_EXT;

     // compute the internal texture format, this set the _internalFormat to an appropriate value.
@@ -274,7 +303,7 @@ SparseTexture2DArray::applyTexImage2DArray_subload(osg::State& state, osg::Image
     bool compressed_image = isCompressedInternalFormat((GLenum)image->getPixelFormat());

     // if the required layer is exceeds the maximum allowed layer sizes
-    if (indepth > extensions->maxLayerCount())
+    if (indepth > maxLayerCount)
     {
         // we give a warning and do nothing
         OSG_WARN<<"Warning: Texture2DArray::applyTexImage2DArray_subload(..) the given layer number exceeds the maximum number of supported layers."<<std::endl;
@@ -282,10 +311,10 @@ SparseTexture2DArray::applyTexImage2DArray_subload(osg::State& state, osg::Image
     }

     //Rescale if resize hint is set or NPOT not supported or dimensions exceed max size
-    if( _resizeNonPowerOfTwoHint || !texExtensions->isNonPowerOfTwoTextureSupported(_min_filter)
-        || inwidth > extensions->max2DSize()
-        || inheight > extensions->max2DSize())
-        image->ensureValidSizeForTexturing(extensions->max2DSize());
+    if( _resizeNonPowerOfTwoHint || !isNonPowerOfTwoTextureSupported
+        || inwidth > max2DSize
+        || inheight > max2DSize)
+        image->ensureValidSizeForTexturing(max2DSize);

     // image size or format has changed, this is not allowed, hence return
     if (image->s()!=inwidth ||
@@ -299,7 +328,7 @@ SparseTexture2DArray::applyTexImage2DArray_subload(osg::State& state, osg::Image
     glPixelStorei(GL_UNPACK_ALIGNMENT,image->getPacking());

     bool useHardwareMipmapGeneration =
-        !image->isMipmap() && _useHardwareMipMapGeneration && texExtensions->isGenerateMipMapSupported();
+        !image->isMipmap() && _useHardwareMipMapGeneration && generateMipMapSupported;

     // if no special mipmapping is required, then
     if( _min_filter == LINEAR || _min_filter == NEAREST || useHardwareMipmapGeneration )
diff --git a/src/osgEarth/VirtualProgram.cpp b/src/osgEarth/VirtualProgram.cpp
index 399f8e3..a3cedaf 100644
--- a/src/osgEarth/VirtualProgram.cpp
+++ b/src/osgEarth/VirtualProgram.cpp
@@ -27,6 +27,10 @@
 #include <osg/Program>
 #include <osg/State>
 #include <osg/Notify>
+#include <osg/Version>
+#include <osg/GL2Extensions>
+#include <osg/GLExtensions>
+#include <fstream>
 #include <sstream>
 #include <OpenThreads/Thread>

@@ -1012,7 +1015,12 @@ VirtualProgram::apply( osg::State& state ) const
         // as the default fallback, we use the "_inheritSet" flag to differeniate. This
         // prevents any shader leakage from a VP-enabled node.
         const osg::GL2Extensions* extensions = osg::GL2Extensions::Get(contextID,true);
-        if( ! extensions->isGlslSupported() ) return;
+#if OSG_MIN_VERSION_REQUIRED(3,3,3)
+		if( ! extensions->isGlslSupported ) return;
+#else
+		if( ! extensions->isGlslSupported() ) return;
+#endif
+

         extensions->glUseProgram( 0 );
         state.setLastAppliedProgramObject(0);
diff --git a/src/osgEarthDrivers/engine_mp/MPGeometry.cpp b/src/osgEarthDrivers/engine_mp/MPGeometry.cpp
index 613503e..1e3d6a4 100644
--- a/src/osgEarthDrivers/engine_mp/MPGeometry.cpp
+++ b/src/osgEarthDrivers/engine_mp/MPGeometry.cpp
@@ -25,6 +25,7 @@
 #include <osgEarth/Capabilities>

 #include <osgUtil/IncrementalCompileOperation>
+#include <osg/Version>

 using namespace osg;
 using namespace osgEarth::Drivers::MPTerrainEngine;
@@ -95,13 +96,22 @@ MPGeometry::renderPrimitiveSets(osg::State& state,

     // access the GL extensions interface for the current GC:
     const osg::Program::PerContextProgram* pcp = 0L;
+
+#if OSG_MIN_VERSION_REQUIRED(3,3,3)
+	osg::ref_ptr<osg::GLExtensions> ext;
+#else
     osg::ref_ptr<osg::GL2Extensions> ext;
+#endif
     unsigned contextID;

     if (_supportsGLSL)
     {
         contextID = state.getContextID();
-        ext = osg::GL2Extensions::Get( contextID, true );
+#if OSG_MIN_VERSION_REQUIRED(3,3,3)
+		ext = osg::GLExtensions::Get(contextID, true);
+#else
+		ext = osg::GL2Extensions::Get( contextID, true );
+#endif
         pcp = state.getLastAppliedProgramObject();
     }

@@ -486,7 +496,12 @@ MPGeometry::compileGLObjects( osg::RenderInfo& renderInfo ) const

     State& state = *renderInfo.getState();
     unsigned contextID = state.getContextID();
+
+#if OSG_MIN_VERSION_REQUIRED(3,3,3)
+    osg::GLExtensions* extensions = osg::GLExtensions::Get(contextID, true);
+#else
     GLBufferObject::Extensions* extensions = GLBufferObject::getExtensions(contextID, true);
+#endif
     if (!extensions)
         return;
