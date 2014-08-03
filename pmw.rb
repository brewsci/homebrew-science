require 'formula'

class Pmw < Formula
  homepage 'http://pmw.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/pmw/Pmw/Pmw.1.3.3/Pmw.1.3.3.tar.gz'
  sha1 '0ff7f03245640da4f37a97167967de8d09e4c6a6'

  depends_on 'Tkinter' => :python

  devel do
    url 'https://downloads.sourceforge.net/project/pmw/Pmw2/Pmw.2.0.0-alpha/Pmw.2.0.0.tar.gz'
    sha1 '88cd160c32617a2da1b06d567710336156ac0a71'
  end

  def install
    # Pmw cannot be installed with pip because it is not in PyPI and
    # `pip install ${URL}` fails. This is probably because of the
    # strange directory tree, which puts everythin into a "src/" dir
    temp_site_packages = lib/which_python/'site-packages'
    mkdir_p temp_site_packages

    args = [
      "build",
      "install",
      "--install-lib=#{temp_site_packages}",
    ]

    system "python", "-s", "setup.py", *args

  end

  test do
    system "python", "-c", "import Pmw"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
