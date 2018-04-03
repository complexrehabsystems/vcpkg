$VcpkgInstallRoot = (pwd).Path + "\installed\"

[Environment]::SetEnvironmentVariable("VCPKG_ROOT_X86", $VcpkgInstallRoot + "x86-windows\", "Machine")
[Environment]::SetEnvironmentVariable("VCPKG_ROOT_X64", $VcpkgInstallRoot + "x64-windows\", "Machine")