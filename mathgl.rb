require 'formula'

class Mathgl < Formula
  def self.with_qt? version
    version.to_s == ARGV.value('with-qt')
  end

  def with_qt? version
    self.class.with_qt? version
  end

  homepage 'http://mathgl.sourceforge.net/'
  url 'https://downloads.sourceforge.net/mathgl/mathgl-2.2.2.1.tar.gz'
  sha1 '7d450028728384782315d4d5f5c4dd8b67c29e3b'

  option 'with-qt=', 'Build with Qt 4 or 5 support'

  depends_on 'cmake'   => :build
  depends_on 'gsl'     => :recommended
  depends_on 'jpeg'    => :recommended
  depends_on 'libharu' => :recommended
  depends_on "libpng"  => :recommended
  depends_on 'hdf5'    => :optional
  depends_on 'fltk'    => :optional
  depends_on 'wxmac'   => :optional
  depends_on 'giflib'  => :optional
  depends_on 'qt'  if with_qt? 4
  depends_on 'qt5' if with_qt? 5
  depends_on :x11  if build.with? 'fltk'

  def install
    args = std_cmake_args + %w[
      -Denable-glut=ON
      -Denable-gsl=ON
      -Denable-jpeg=ON
      -Denable-pthread=ON
      -Denable-pdf=ON
      -Denable-python=OFF
      -Denable-octave=OFF
    ]

    args << '-Denable-openmp=' + ((ENV.compiler == :clang) ? 'OFF' : 'ON')
    args << '-Denable-qt4=ON'     if with_qt? 4
    args << '-Denable-qt5=ON'     if with_qt? 5
    args << '-Denable-gif=ON'     if build.with? 'giflib'
    args << '-Denable-hdf5_18=ON' if build.with? 'hdf5'
    args << '-Denable-fltk=ON'    if build.with? 'fltk'
    args << '-Denable-wx=ON'      if build.with? 'wxmac'
    args << '..'
    rm 'ChangeLog' if File.exist? 'ChangeLog' # rm this problematic symlink.
    mkdir 'brewery' do
      system 'cmake', *args
      system 'make install'
      cd 'examples' do
        bin.install Dir['mgl*_example']
      end
    end
  end

  test do
    system "#{bin}/mgl_example"
  end
end
