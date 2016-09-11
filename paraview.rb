class Paraview < Formula
  desc "Multi-platform data analysis and visualization application"
  homepage "http://paraview.org"
  url "http://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v4.2&type=source&os=all&downloadFile=ParaView-v4.2.0-source.tar.gz"
  sha256 "ac26cc5fe5ce82d27531727a01242353d40984826eaa580edea0791887a07b6b"
  revision 3

  head "git://paraview.org/ParaView.git"

  bottle do
    sha256 "6b0ba118d11cc06d1b0e40cb21310f4006b365e303c1329d35c65afdec9e5eb1" => :el_capitan
    sha256 "eff0507e5af1fd32d0349234d5c12789dcd265031eef7f349349be5cabd0dff7" => :yosemite
    sha256 "466cdc819cce128dc4cafab98193d8dac64b1cb8992933d94ba3850cd5ecd463" => :mavericks
  end

  depends_on "cmake" => :build

  depends_on "boost" => :recommended
  depends_on "cgns" => :recommended
  depends_on "ffmpeg" => :recommended
  depends_on "qt" => :recommended
  depends_on :mpi => [:cc, :cxx, :optional]
  depends_on :python => :recommended

  depends_on "freetype"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "fontconfig"
  depends_on "libpng"

  # Temporary fix for a cast issue related to FreeType.
  # See https://bugs.gentoo.org/show_bug.cgi?id=533444
  # Fix long-standing bug related to a changing FFMPEG API.
  # See http://www.paraview.org/Bug/view.php?id=14215
  # https://gitlab.kitware.com/paraview/paraview/issues/14215
  # and http://www.paraview.org/Bug/view.php?id=16001
  patch :DATA unless build.head?

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DMACOSX_APP_INSTALL_PREFIX:PATH=#{prefix}
      -DPARAVIEW_DO_UNIX_STYLE_INSTALLS:BOOL=OFF
      -DVTK_USE_SYSTEM_EXPAT:BOOL=ON
      -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON
      -DVTK_USE_SYSTEM_HDF5:BOOL=ON
      -DVTK_USE_SYSTEM_JPEG:BOOL=ON
      -DVTK_USE_SYSTEM_LIBXML2:BOOL=ON
      -DVTK_USE_SYSTEM_PNG:BOOL=ON
      -DVTK_USE_SYSTEM_TIFF:BOOL=ON
      -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
    ]

    args << "-DPARAVIEW_BUILD_QT_GUI:BOOL=OFF" if build.without? "qt"
    args << "-DPARAVIEW_USE_MPI:BOOL=ON" if build.with? "mpi"
    args << "-DPARAVIEW_ENABLE_FFMPEG:BOOL=ON" if build.with? "ffmpeg"
    args << "-DPARAVIEW_USE_VISITBRIDGE:BOOL=ON" if build.with? "boost"
    args << "-DVISIT_BUILD_READER_CGNS:BOOL=ON" if build.with? "cgns"

    mkdir "build" do
      if build.with? "python"
        args << "-DPARAVIEW_ENABLE_PYTHON:BOOL=ON"
        # CMake picks up the system"s python dylib, even if we have a brewed one.
        args << "-DPYTHON_LIBRARY='#{`python-config --prefix`.chomp}/lib/libpython2.7.dylib'"
      else
        args << "-DPARAVIEW_ENABLE_PYTHON:BOOL=OFF"
      end
      args << ".."

      system "cmake", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    shell_output("#{opt_prefix}/paraview.app/Contents/MacOS/paraview --version", 1)
  end
end

__END__
diff --git a/VTK/Rendering/FreeType/vtkFreeTypeTools.cxx b/VTK/Rendering/FreeType/vtkFreeTypeTools.cxx
index fcbb323..7a48f62 100644
--- a/VTK/Rendering/FreeType/vtkFreeTypeTools.cxx
+++ b/VTK/Rendering/FreeType/vtkFreeTypeTools.cxx
@@ -1183,7 +1183,7 @@ bool vtkFreeTypeTools::CalculateBoundingBox(const T& str,
     if (bitmap)
       {
       metaData.ascent = std::max(bitmapGlyph->top - 1, metaData.ascent);
-      metaData.descent = std::min(-(bitmap->rows - (bitmapGlyph->top - 1)),
+      metaData.descent = std::min(-(static_cast<int>(bitmap->rows) - (bitmapGlyph->top - 1)),
                                   metaData.descent);
       }
     ++heightString;
@@ -1950,8 +1950,8 @@ void vtkFreeTypeTools::GetLineMetrics(T begin, T end, MetaData &metaData,
     if (bitmap)
       {
       bbox[0] = std::min(bbox[0], pen[0] + bitmapGlyph->left);
-      bbox[1] = std::max(bbox[1], pen[0] + bitmapGlyph->left + bitmap->width);
-      bbox[2] = std::min(bbox[2], pen[1] + bitmapGlyph->top - 1 - bitmap->rows);
+      bbox[1] = std::max(bbox[1], pen[0] + bitmapGlyph->left + static_cast<int>(bitmap->width));
+      bbox[2] = std::min(bbox[2], pen[1] + bitmapGlyph->top - 1 - static_cast<int>(bitmap->rows));
       bbox[3] = std::max(bbox[3], pen[1] + bitmapGlyph->top - 1);
       }
     else
diff --git a/VTK/IO/FFMPEG/vtkFFMPEGWriter.cxx b/VTK/IO/FFMPEG/vtkFFMPEGWriter.cxx
index 387a993..9e159c8 100644
--- a/VTK/IO/FFMPEG/vtkFFMPEGWriter.cxx
+++ b/VTK/IO/FFMPEG/vtkFFMPEGWriter.cxx
@@ -189,11 +189,11 @@ int vtkFFMPEGWriterInternal::Start()
   c->height = this->Dim[1];
   if (this->Writer->GetCompression())
     {
-    c->pix_fmt = PIX_FMT_YUVJ422P;
+    c->pix_fmt = AV_PIX_FMT_YUVJ422P;
     }
   else
     {
-    c->pix_fmt = PIX_FMT_BGR24;
+    c->pix_fmt = AV_PIX_FMT_BGR24;
     }

   //to do playback at actual recorded rate, this will need more work see also below
@@ -272,13 +272,13 @@ int vtkFFMPEGWriterInternal::Start()
 #endif

   //for the output of the writer's input...
-  this->rgbInput = avcodec_alloc_frame();
+  this->rgbInput = av_frame_alloc();
   if (!this->rgbInput)
     {
     vtkGenericWarningMacro (<< "Could not make rgbInput avframe." );
     return 0;
     }
-  int RGBsize = avpicture_get_size(PIX_FMT_RGB24, c->width, c->height);
+  int RGBsize = avpicture_get_size(AV_PIX_FMT_RGB24, c->width, c->height);
   unsigned char *rgb = new unsigned char[RGBsize];
   if (!rgb)
     {
@@ -286,10 +286,10 @@ int vtkFFMPEGWriterInternal::Start()
     return 0;
     }
   //The rgb buffer should get deleted when this->rgbInput is.
-  avpicture_fill((AVPicture *)this->rgbInput, rgb, PIX_FMT_RGB24, c->width, c->height);
+  avpicture_fill((AVPicture *)this->rgbInput, rgb, AV_PIX_FMT_RGB24, c->width, c->height);

   //and for the output to the codec's input.
-  this->yuvOutput = avcodec_alloc_frame();
+  this->yuvOutput = av_frame_alloc();
   if (!this->yuvOutput)
     {
     vtkGenericWarningMacro (<< "Could not make yuvOutput avframe." );
@@ -352,7 +352,7 @@ int vtkFFMPEGWriterInternal::Write(vtkImageData *id)
 #else
   //convert that to YUV for input to the codec
   SwsContext* convert_ctx = sws_getContext(
-    cc->width, cc->height, PIX_FMT_RGB24,
+    cc->width, cc->height, AV_PIX_FMT_RGB24,
     cc->width, cc->height, cc->pix_fmt,
     SWS_BICUBIC, NULL, NULL, NULL);
