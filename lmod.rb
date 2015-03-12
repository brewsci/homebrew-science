class Lmod < Formula
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://downloads.sourceforge.net/project/lmod/Lmod-5.9.tar.bz2"
  sha256 "d22c58f0a2b863481a6b9c0d6a3528ac4d96ed648b8aec90d0425c318ce46cab"

  depends_on "lua"
  depends_on "luarocks" => :recommended
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
