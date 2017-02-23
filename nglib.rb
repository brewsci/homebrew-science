class Nglib < Formula
  desc "C++ Library of NETGEN's tetrahedral mesh generator"
  homepage "https://sourceforge.net/projects/netgen-mesher/"
  url "https://downloads.sourceforge.net/project/netgen-mesher/netgen-mesher/5.3/netgen-5.3.1.tar.gz"
  sha256 "cb97f79d8f4d55c00506ab334867285cde10873c8a8dc783522b47d2bc128bf9"
  revision 1

  bottle do
    cellar :any
    sha256 "b196f891e9ee6bcbde3da4bed5b94ba5e781e41d229ec6086770ce17dcaf4481" => :sierra
    sha256 "b5c8261d19aa2f1f9c12a852329f914e6f870a951a91f46559c8ebcaa423e398" => :el_capitan
    sha256 "d83be6b9c3c153c1ef4c806be4013fe076cc34beb46a3ef671efc79dac728f30" => :yosemite
    sha256 "7ef9d64db91c761ab96a348a12290b7f4ea05009405a35775af0850616fea956" => :x86_64_linux
  end

  # These two conflict with each other, so we'll have at most one.
  depends_on "opencascade" => :recommended
  depends_on "oce" => :optional

  # Patch two main issues:
  #   Makefile - remove TCL scripts that aren't reuquired without NETGEN.
  #   Partition_Loop2d.cxx - Fix PI that was used rather than M_PI
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/20850ac/nglib/define-PI-and-avoid-tcl-install.diff"
    sha256 "1f97e60328f6ab59e41d0fa096acbe07efd4c0a600d8965cc7dc5706aec25da4"
  end

  # OpenCascase 7.x compatibility patches
  if build.with? "opencascade"
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/20850ac/nglib/occt7.x-compatibility-patches.diff"
      sha256 "c3f222b47c5da2cf8f278718dbc599fab682546380210a86a6538c3f2d9f1b27"
    end
  end

  def install
    ENV.cxx11 if build.with? "opencascade"

    cad_kernel = Formula[build.with?("opencascade") ? "opencascade" : "oce"]

    # Set OCC search path to Homebrew prefix
    inreplace "configure" do |s|
      s.gsub!(%r{(OCCFLAGS="-DOCCGEOMETRY -I\$occdir/inc )(.*$)}, "\\1-I#{cad_kernel.opt_include}/#{cad_kernel}\"")
      s.gsub!(/(^.*OCCLIBS="-L.*)( -lFWOSPlugin")/, "\\1\"") if build.with? "opencascade"
      s.gsub!(%r{(OCCLIBS="-L\$occdir/lib)(.*$)}, "\\1\"") if OS.mac?
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gui
      --enable-nglib
    ]

    if build.with?("opencascade") || build.with?("oce")
      args << "--enable-occ"

      if build.with? "opencascade"
        args << "--with-occ=#{cad_kernel.opt_prefix}"

      else
        args << "--with-occ=#{cad_kernel.opt_prefix}/include/oce"

        # These fix problematic hard-coded paths in the netgen make file
        args << "CPPFLAGS=-I#{cad_kernel.opt_prefix}/include/oce"
        args << "LDFLAGS=-L#{cad_kernel.opt_prefix}/lib/"
      end
    end

    system "./configure", *args

    system "make", "install"

    # The nglib installer doesn't include some important headers by default.
    # This follows a pattern used on other platforms to make a set of sub
    # directories within include/ to contain these headers.
    subdirs = ["csg", "general", "geom2d", "gprim", "include", "interface",
               "linalg", "meshing", "occ", "stlgeom", "visualization"]
    subdirs.each do |subdir|
      (include/"netgen"/subdir).mkpath
      (include/"netgen"/subdir).install Dir.glob("libsrc/#{subdir}/*.{h,hpp}")
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include<iostream>
      namespace nglib {
          #include <nglib.h>
      }
      int main(int argc, char **argv) {
          nglib::Ng_Init();
          nglib::Ng_Mesh *mesh(nglib::Ng_NewMesh());
          nglib::Ng_DeleteMesh(mesh);
          nglib::Ng_Exit();
          return 0;
      }
    EOS
    system ENV.cxx, "-Wall", "-o", "test", "test.cpp",
           "-I#{include}", "-L#{lib}", "-lnglib", "-lTKIGES"
    system "./test"
  end
end
