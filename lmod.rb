class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://github.com/TACC/Lmod/archive/7.5.1.tar.gz"
  sha256 "52a8ab4120896276bbfb462f200e0ee36893781cd961477736888d32138fa86d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c03c1fe1323ff232f3adf62fd091325c6dad88e0cacbc5932dd15dd88f4c5e5d" => :sierra
    sha256 "c293f8082250b35cc68119718e0d1d940a445088568b3b927e507cf6b0682a76" => :el_capitan
    sha256 "3ef583fd7cc63e560bc04fa97facfa1d022ac3398d7eb41f2ce9b720ac4c5092" => :yosemite
    sha256 "731f23d3ed646a94eeadaa312fd6f6d3ece0b48f49e89816544243315c5bf1e7" => :x86_64_linux
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
