class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://github.com/TACC/Lmod/archive/7.6.11.tar.gz"
  sha256 "8476df95d301227eb6a392eb942b7c4b9df600106564ecf73eb22ac2511dfc80"

  bottle do
    cellar :any_skip_relocation
    sha256 "7343fe8972e47aa1028024b4dfeeb7b07aaa99ff0c2d5db9a295af5d7ca8cace" => :sierra
    sha256 "c33e62bc2f92866df6764415c3fa2f22d637340da650dfa142104d85efa0e733" => :el_capitan
    sha256 "91641b6a04c6cfde2cb046af3782658a008de07f0baf29adde7889327b684f22" => :yosemite
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
