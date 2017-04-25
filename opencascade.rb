class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://dev.opencascade.org/"
  url "https://github.com/FreeCAD/homebrew-freecad/releases/download/0/opencascade-7.1.0.tgz"
  sha256 "8aaf1e29edc791ad611172dcbcc6efa35ada1e02a5eb7186a837131f85231d71"
  revision 1

  bottle do
    cellar :any
    sha256 "e817f05ac747235d8453a2d15fb076f90f87b30a872ff6944cc5487f05058cbe" => :sierra
    sha256 "9be44acf5036801dda4981b48693312f7cba3daffa73e80c50ea207a9da7407e" => :el_capitan
    sha256 "790964a5e17e0021228f03b32bdabdc1657aa89aa56f668d8b998ec5f1ce42bc" => :yosemite
    sha256 "5ef4d49225c00242f5ab1cc04804f3d4b931c2fc82713c4a9457e57c50f94c33" => :x86_64_linux
  end

  option "without-opencl", "Build without OpenCL support" if OS.mac?
  option "with-extras", "Install documentation (~17 MB), source files (~113 MB), samples and templates"
  option "with-test", "Install tests (~55MB)"
  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "freeimage" => :recommended
  depends_on "tbb"       => :recommended
  depends_on "gl2ps"     => :recommended if OS.mac? # Not yet available in Linuxbrew
  depends_on "doxygen"   if build.with? "extras"
  depends_on :macos      => :snow_leopard

  unless OS.mac?
    depends_on :x11
    depends_on "tcl-tk"
    depends_on "linuxbrew/xorg/mesa"
  end

  conflicts_with "oce", :because => "OCE is a fork for patches/improvements/experiments over OpenCascade"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DCMAKE_PREFIX_PATH:PATH=#{HOMEBREW_PREFIX}"
    cmake_args << "-DCMAKE_INCLUDE_PATH:PATH=#{HOMEBREW_PREFIX}/lib"
    cmake_args << "-D3RDPARTY_DIR:PATH=#{HOMEBREW_PREFIX}"
    cmake_args << "-DINSTALL_TESTS:BOOL=ON" if build.with? "tests"
    cmake_args << "-D3RDPARTY_TBB_DIR:PATH=#{HOMEBREW_PREFIX}" if build.with? "tbb"

    %w[freeimage gl2ps opencl tbb].each do |feature|
      cmake_args << "-DUSE_#{feature.upcase}:BOOL=ON" if build.with? feature
    end

    if OS.mac?
      sdk_path = Pathname.new `xcrun --show-sdk-path`.strip
      cmake_args << "-D3RDPARTY_TCL_DIR:PATH=/usr"
      cmake_args << "-D3RDPARTY_TCL_INCLUDE_DIR:PATH=#{sdk_path}/usr/include/"
      cmake_args << "-D3RDPARTY_TK_INCLUDE_DIR:PATH=#{sdk_path}/usr/include/"
      cmake_args << "-DCMAKE_FRAMEWORK_PATH:PATH=#{HOMEBREW_PREFIX}/Frameworks"
      cmake_args << "-D3RDPARTY_FREETYPE_INCLUDE_DIR:PATH=#{HOMEBREW_PREFIX}/include/freetype2"
      opencl_path = Pathname.new "#{sdk_path}/System/Library/Frameworks/OpenCL.framework/Versions/Current"
      if build.with?("opencl") && opencl_path.exist?
        cmake_args << "-D3RDPARTY_OPENCL_INCLUDE_DIR:PATH=#{opencl_path}/Headers"
        cmake_args << "-D3RDPARTY_OPENCL_DLL:FILEPATH=#{opencl_path}/Libraries/libcl2module.dylib"
      end
    else
      cmake_args << "-D3RDPARTY_TCL_DIR:PATH=#{Formula["tcl-tk"].prefix}"
      cmake_args << "-D3RDPARTY_TCL_INCLUDE_DIR:PATH=#{HOMEBREW_PREFIX}/include"
      cmake_args << "-D3RDPARTY_TK_INCLUDE_DIR:PATH=#{HOMEBREW_PREFIX}/include"
    end

    if build.with? "extras"
      cmake_args << "-DINSTALL_SAMPLES=ON"
      cmake_args << "-DINSTALL_DOC_Overview:BOOL=ON"
    end

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"

      if build.with? "extras"
        prefix.install "../src"
        prefix.install "../adm"
        share.install_symlink prefix/"adm"
      else
        # Some apss expect resoures in legacy ${CASROOT}/src directory
        cd prefix do
          ln_s "share/opencascade/resources", "src"
        end
      end
    end

    # add symlinks to be able to compile against OpenCascade
    loc = OS.mac? ? "#{prefix}/mac64/clang" : "#{prefix}/lin64/gcc"
    bin.install_symlink Dir["#{loc}/bin/*"]
    lib.install_symlink Dir["#{loc}/lib/*"]
  end

  def caveats; <<-EOF.undent
    Some apps will require this enviroment variable:
      CASROOT=#{opt_prefix}
    EOF
  end

  test do
    ENV["CASROOT"] = opt_prefix
    "1\n"==`#{bin}/DRAWEXE -c \"pload ALL\"`
  end
end
