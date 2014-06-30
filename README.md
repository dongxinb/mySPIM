mySPIM
======

A MIPS assembler/disassembler/simulator written in objective-C

计算机系统原理project，集成了assembler/disassembler/simulator。

# Function

* MIPS指令转化成机器码
* 机器码转化为MIPS指令
* MIPS模拟运行
* 即时查看寄存器信息（寄存器变化会用红色字体标出）
* 即时查看内存信息
* 单步调试
* 标记已经运行到的地址
* 图形界面

# Support
支持如下指令：

`j, addi, beq, bne, lw, sw, slti`

`add, sub, and, or, xor, slt`

其他指令还是比较方便添加的。

同时，支持label（会自动转化成地址）

# To do
因为是花了一个通宵赶DDL赶出来的，我已经很用心的避免bug的出现，但是在后续测试中还是发现了若干bug，请自行修复。

也正是如此，代码比较糟糕有很多需要优化甚至需要重写等等……

待完善：

* 指令错误未提示（返回null）
* 虚拟内存
* 显存

# Environment
* Mac OS X 10.9.3
* Xcode 5

# License
Under the MIT license

