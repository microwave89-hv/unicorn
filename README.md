Unicorn x86
==============

Lightweight, x86 CPU emulator framework heavily based on [Unicorn Engine](https://www.unicorn-engine.org/).
All unneeded architectures have been stripped and the build was tailored to macOS (High Sierra) (Only native x64).

This currently offers the following features:
  - Single-architecture: x86 (16, 32, 64-bit)
  - Clean/simple/lightweight/intuitive architecture-neutral API
  - Implemented in pure C language, with no bindings whatsoever (Use PyPi to get Python binding)
  - Runs on macOS High Sierra (Tested!)
  - High performance via Just-In-Time compilation <== Remove this feature for uncomplicating matters!
  - Builtin basic x86 test cases
  - Support for fine-grained instrumentation at various levels <== ??
  - Thread-safety by design <== Possibly remove that too for uncomplicating matters!
  - Distributed under free software license GPLv2

This __aims__ to offer the following features in the future:
  - Execution from the reset vector @ 0xfffffff0
  - Fully track and emulate mode-switches between real mode, 16-bit pmode, 32-bit pmode, and long mode
  - Realistic CPU model for Intel(R) Core 2 Duo T9600, Intel(R) Core i7 3720QM, and Intel(R) Core i7 4960HQ

Further information is available at (null)


License
-------

This project is released under the [GPL license](COPYING).


Compilation
------------------

```
$ cd <unicorn-dir>
$ make full
```
