class Mpv < Formula
  desc "Free, open source, and cross-platform media player"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.18.0.tar.gz"
  sha256 "b656638d4f6bce2621baaacb60d8be384aa492fcd86dfd43996aaa2c16fee02b"
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "67be0ca312f28797543e781b9449f48593ca6c25446031a334c235864b829be9" => :el_capitan
    sha256 "6b6559bc6d4dab13be590afff7fd637b52f01365ed0ec2cea6f1e84b801ea6e0" => :yosemite
    sha256 "6df154963d1757f6abb2b5255049fd3e91c7585fa72bd8b02834e3448e4117fe" => :mavericks
  end

  option "with-bundle", "Enable compilation of the .app bundle."

  depends_on "pkg-config" => :build
  depends_on :python3

  depends_on "libass"
  depends_on "ffmpeg"

  depends_on "jpeg" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "lua" => :recommended
  depends_on "youtube-dl" => :recommended

  depends_on "libarchive" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libdvdnav" => :optional
  depends_on "libbluray" => :optional
  depends_on "libaacs" => :optional
  depends_on "vapoursynth" => :optional
  depends_on "uchardet" => :optional
  depends_on :x11 => :optional

  depends_on :macos => :mountain_lion

  resource "waf" do
    url "https://waf.io/waf-1.8.21"
    sha256 "31383a18d183c72be70d251e09b47389a6eb4bebbc94b737cff3187ddd88dff1"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/37/38/ceda70135b9144d84884ae2fc5886c6baac4edea39550f28bcd144c1234d/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  def install
    # LANG is unset by default on osx and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    version = Language::Python.major_minor_version("python3")
    ENV.prepend_create_path "PKG_CONFIG_PATH", Pathname.new(`python3-config --prefix`.chomp)/"lib/pkgconfig"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PATH", libexec/"bin"
    resource("docutils").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    args = %W[
      --prefix=#{prefix}
      --enable-zsh-comp
      --enable-libmpv-shared
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --zshdir=#{zsh_completion}
    ]
    args << "--enable-libarchive" if build.with? "libarchive"

    waf = resource("waf")
    buildpath.install waf.files("waf-#{waf.version}" => "waf")
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"

    if build.with? "bundle"
      system "python3", "TOOLS/osxbundle.py", "build/mpv"
      prefix.install "build/mpv.app"
    end
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
