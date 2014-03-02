require 'formula'

class Mathgl < Formula
  homepage 'http://mathgl.sourceforge.net/'
  url 'https://downloads.sourceforge.net/mathgl/mathgl-2.2.1.tar.gz'
  sha1 '49279952f97a65f8ec5ba89ed66313b48e06573d'

  depends_on 'cmake'   => :build
  depends_on 'gsl'     => :recommended
  depends_on 'jpeg'    => :recommended
  depends_on 'libharu' => :recommended
  depends_on :libpng   => :recommended
  depends_on 'hdf5'    => :optional
  depends_on 'fltk'    => :optional
  depends_on 'qt'      => :optional
  depends_on 'wxmac'   => :optional
  depends_on 'giflib'  => :optional
  depends_on :x11 if build.with? 'fltk'

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
    args << '-Denable-qt=ON'      if build.with? 'qt'
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
