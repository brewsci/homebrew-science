class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://github.com/TACC/Lmod/archive/7.6.11.tar.gz"
  sha256 "8476df95d301227eb6a392eb942b7c4b9df600106564ecf73eb22ac2511dfc80"

  bottle do
    cellar :any_skip_relocation
    sha256 "943bfef305722236387c79c88f1457b50c6740524c8baa0e74ffc5aa2f83114b" => :sierra
    sha256 "281d6a2bccc2b93bad8a3cd6dd46a96af0e6fbefded4fcea8475b2a332544bb1" => :el_capitan
    sha256 "9e6f834c722de8b856808469da9d9bad532a89154ece8c304e03a8b870a67202" => :yosemite
    sha256 "c24afe4a6eb4846119bcad2cd78d9256d8bc2c791451582dd646771012f38d6f" => :x86_64_linux
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
