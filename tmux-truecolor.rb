require 'formula'

class TmuxTruecolor < Formula
  homepage 'http://tmux.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/tmux/tmux/tmux-2.0/tmux-2.0.tar.gz'
  sha1 '977871e7433fe054928d86477382bd5f6794dc3d'

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  if build.head?
    patch :p1 do
      url "https://gist.githubusercontent.com/zchee/9f6f2ca17acf49e04088/raw/0c9bf0d84e69cb49b5e59950dd6dde6ca265f9a1/tmux-truecolor.diff"
      sha256 "17572f1d40917a3900216b095b719c401451c93a1c61288c675a980d8031f275"
    end
  elsif
    patch :p1 do
      url "https://gist.githubusercontent.com/JohnMorales/0579990993f6dec19e83/raw/75b073e85f3d539ed24907f1615d9e0fa3e303f4/tmux-24.diff"
      sha256 "66207daba09783c49ea61d9b84f54cb5ce002054eea489fbe401306f6d1b7c56"
    end

    patch :p2 do
      url "https://gist.githubusercontent.com/zchee/5d712d43d1993eb60629/raw/e8d1151b1b81234700fad30ef485160c826e30e5/tmux-hangs.diff"
      sha256 "d18e8a3b47d283fbbefb850369362127345117eacc5b8371fa8505061af7df08"
    end
  end

  depends_on 'pkg-config' => :build
  depends_on 'libevent'

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"

    bash_completion.install "examples/bash_completion_tmux.sh" => 'tmux'
    (share/'tmux').install "examples"
  end

  def caveats; <<-EOS.undent
    Example configurations have been installed to:
      #{share}/tmux/examples
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
