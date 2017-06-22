class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://github.com/TACC/Lmod/archive/7.5.2.tar.gz"
  sha256 "f1f540fa2ddd61db31b73ac59e6e630373431b88f6630ee9254f4fdfb2e855d1"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4b2b80d48e1376d71984aef0217e7e0d89278ca93cf64f4c717628e6e7416843" => :sierra
    sha256 "6c76f575aa453ae66cb744c6e9ef2ad05dad327956a2d73f894dbc5feec3bf55" => :el_capitan
    sha256 "be4c88d61a1d0c0f2a98069c3596ba44b9fadcab7445f7e4d7a196569fffb74c" => :yosemite
    sha256 "7c09fd9f394096424f66e71bf6c66faad0e552b26c9d156d9c5eae2e51bcab7e" => :x86_64_linux
  end

  depends_on "lua"

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v_1_6_3.tar.gz"
    sha256 "5525d2b8ec7774865629a6a29c2f94cb0f7e6787987bf54cd37e011bfb642068"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/v34.0.tar.gz"
    sha256 "ebe638078b9a72f73f0b9b8ae959032e5590d2d6b303e59154be1fb073563f71"
  end

  def install
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/5.2/?.lua" \
                      ";#{luapath}/share/lua/5.2/?/init.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.2/?.so"

    resources.each do |r|
      r.stage do
        system "luarocks", "build", r.name, "--tree=#{luapath}"
      end
    end

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
    Dir[prefix/"lmod/init/*"].reject { |f| f["lmodrc.lua"] }.each do |f|
      inreplace f, "lmod/lmod", "lmod"
    end
  end

  test do
    system "#{prefix}/lmod/init/sh"
  end
end
