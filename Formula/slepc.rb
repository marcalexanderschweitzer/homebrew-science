# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
 class Slepc < Formula
  desc ""
  homepage ""
  # url "http://slepc.upv.es/download/distrib/slepc-3.8.2.tar.gz"
  # sha256 "1e7d20d20eb26da307d36017461fe4a55f40e947e232739179dbe6412e22ed13"
  url "http://slepc.upv.es/download/distrib/slepc-3.9.0.tar.gz"
  sha256 "1f3930db56b4065aaf214ea758ddff1a70bf19d45544cbdfd19d2787db4bfe0b"


  bottle :disable, "needs to be rebuilt with latest open-mpi"

  deprecated_option "complex" => "with-complex"

  option "with-complex", "Use complex version by default. Otherwise, real-valued version will be symlinked"
  option "without-test", "Skip run-time tests (not recommended)"
  option "with-openblas", "Install dependencies with openblas"
  option "with-blopex", "Download blopex library"

  deprecated_option "without-check" => "without-test"

  openblasdep = (build.with? "openblas") ? ["with-openblas"] : []

  depends_on "petsc" => openblasdep
  depends_on "open-mpi" => [:cc, :f90]
  depends_on "gcc"
  depends_on "hdf5"
  depends_on :x11 => :optional
  depends_on "arpack" => [:recommended, "with-mpi"] + openblasdep

  def install
    ENV.deparallelize

    # these must be consistent with petsc.rb
    petsc_arch_real = "real"
    petsc_arch_complex = "complex"

    ENV["SLEPC_DIR"] = Dir.getwd
    args = ["--with-clean=true"]
    args << "--with-arpack-dir=#{Formula["arpack"].opt_lib}" << "--with-arpack-flags=-lparpack,-larpack" if build.with? "arpack"
    args << "--download-blopex" if build.with? "blopex"

    # real
    ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}/#{petsc_arch_real}"
    system "./configure", "--prefix=#{prefix}/#{petsc_arch_real}", *args
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"

    # complex
    ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}/#{petsc_arch_complex}"
    system "./configure", "--prefix=#{prefix}/#{petsc_arch_complex}", *args
    system "make"
    # TODO: investigate why complex tests fail to run on Linuxbrew
    system "make", "test" if build.with? "test"
    system "make", "install"

    # Link what we need.
    petsc_arch = ((build.include? "complex") ? petsc_arch_complex : petsc_arch_real)

    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*.h"],
                            "#{prefix}/#{petsc_arch}/finclude", "#{prefix}/#{petsc_arch}/slepc-private"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.*"]
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    doc.install "docs/slepc.pdf", Dir["docs/*.htm"], "docs/manualpages" # They're not really man pages.
    pkgshare.install "share/slepc/datafiles"

    # install some tutorials for use in test block
    pkgshare.install "src/eps/examples/tutorials"
  end

  def caveats; <<~EOS
    Set your SLEPC_DIR to #{opt_prefix}/real or #{opt_prefix}/complex.
    Fortran modules are in #{opt_prefix}/real/include and #{opt_prefix}/complex/include.
    EOS
  end

  test do
    cp_r prefix/"share/slepc/tutorials", testpath
    Dir.chdir("tutorials") do
      system "mpicc", "ex1.c", "-I#{opt_include}", "-I#{Formula["petsc"].opt_include}", "-L#{Formula["petsc"].opt_lib}", "-lpetsc", "-L#{opt_lib}", "-lslepc", "-o", "ex1"
      system "mpirun -np 3 ex1 2>&1 | tee ex1.out"
      `cat ex1.out | tail -3 | awk '{print $NF}'`.split.each do |val|
        assert val.to_f < 1.0e-8
      end
    end
  end
end