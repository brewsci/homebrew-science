class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://github.com/TACC/Lmod/archive/7.5.tar.gz"
  sha256 "855cec83b6c08c2420698ed1c4f0b096a9d3915247c42616249f90af5b112023"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbe1649c3ee9afc71cfd5764606d6109ec98ea0f2817b218fac15be67536fdd8" => :sierra
    sha256 "f3e2725ec747d6e1b97475341bf9d25f7ea5e9f12ac3211e6f8c1fdefd6d14dd" => :el_capitan
    sha256 "873f48d4be6c4259b0343cde2e88d3f02fadbe60866428a9796a5f8bd1ab12ad" => :yosemite
    sha256 "d668d97498ab53f76d16a8dffc4e8acb5245232e0d4349294dc76e5942557570" => :x86_64_linux
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
  end

  test do
    system "#{prefix}/lmod/init/sh"
  end
end
