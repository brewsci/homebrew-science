require "formula"

class Paraview < Formula
  homepage "http://paraview.org"
  url "http://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v4.2&type=source&os=all&downloadFile=ParaView-v4.2.0-source.tar.gz"
  sha1 "a440ba9912549bdd23a949e22add41696715dd32"
  head "git://paraview.org/ParaView.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "87c7c0288b7be02298e6b329d5257f622fc60409" => :yosemite
    sha1 "eb0303a16ec842435c693339129c8b8b2c468324" => :mavericks
    sha1 "77fa19bc95a425f2812b7fb14ba929c75b7a4bd2" => :mountain_lion
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
  patch :DATA

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
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
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
    system "#{prefix}/paraview.app/Contents/MacOS/paraview", "--version"
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
