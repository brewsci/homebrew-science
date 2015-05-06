class Lmod < Formula
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://downloads.sourceforge.net/project/lmod/Lmod-5.9.3.tar.bz2"
  sha256 "718593fef9acc37e59cf9cf63ca8dfb2c6f1aa7346707389ef5999cc66d2661f"

  depends_on "lua"
  depends_on "luafilesystem" => :lua
  depends_on "luaposix" => :lua

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"

    # Move prefix/lmod/VERSION/lmod/VERSION/* to prefix/lmod/VERSION/*
    mv Dir[prefix/"lmod/#{version}/*"], prefix
    rmdir prefix/"lmod/#{version}"
    (prefix/"lmod").install_symlink ".." => version
  end

  test do
    system "#{prefix}/lmod/lmod/init/sh"
  end
end
