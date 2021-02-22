# Unicorn is too complex for x86 BIOS simulation
[v] A: Remove all architectures except __x86__

# Unicorn bindings appear to be completely unused
[v] A: Remove all bindings

# cpuid (eax = 0) does not return "GenuineIntel" string
[v] A: In pc.c the CPU is configured to be either "qemu32" or in this case "qemu64", which is an AMD CPU (AuthenticAMD). The CPU must be changed in an Intel(R) one ("core2duo", "SandyBridge", or "Haswell")

# rdmsr (ecx = IA32_PLATFORM_ID) returns 0
[ ] A: Implement MSR 0x17 in helper_rdmsr() in misc_helper.c

# rdmsr (ecx = MSR_BBL_CR_CTL3) returns 0, which leads to bit 0 be 0 ("Indicates if the L2 is hardware-disabled"), and thus leads to CAR initialization fail (infinite loop)
[ ] A: Implement L2 cache..? Fake L2 cache be enabled?