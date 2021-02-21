# Unicorn is too complex for x86 BIOS simulation
[v] A: Remove all architectures except __x86__

# Unicorn bindings appear to be completely unused
[v] A: Remove all bindings

# cpuid (eax = 0) does not return "GenuineIntel" string
[v] A: In pc.c the CPU is configured to be either "qemu32" or in this case "qemu64", which is an AMD CPU (AuthenticAMD). The CPU must be changed in an Intel(R) one ("core2duo", "SandyBridge", or "Haswell")

# rdmsr (ecx = IA32_PLATFORM_ID) returns 0
[ ] A: Implement MSR 0x17 in helper_rdmsr() in misc_helper.c