python
gdb_path = gdb.execute("show configuration", to_string=True).lower()
is_arm = 'arm' in gdb_path
gdb.execute(f'set $is_arm = {1 if is_arm else 0}')
end

set prompt \033[31mgdb$ \033[0m

# 更好的打印输出
set pagination off
# 打印对象时显示对象类型
set print object on
# 优化结构体等的打印格式
set print pretty on
# 优化数组打印格式
set print array on
# 打印数组时显示索引
set print array-indexes on
# 打印字符串时不限制长度
set print elements 0
# 遇到空字符时停止打印字符串
set print null-stop on

# 历史记录
set history filename ~/.gdb_history
set history save
# 增加历史记录数量
set history size 10000
# 移除重复的历史记录
set history remove-duplicates unlimited

# Python 异常时打印回溯信息
set python print-stack full
set auto-load safe-path /
# 跟踪 fork 后的子进程
set follow-fork-mode child
# 减少线程相关的干扰信息
set print thread-events off
# 自动显示下一条要执行的汇编指令
set disassemble-next-line on
if !$is_arm
    set disassembly-flavor intel
end
set print demangle on
set print sevenbit-strings off
set print asm-demangle on
set can-use-hw-watchpoints 1

handle SIGPIPE nostop noprint

# 平台相关
if $is_arm
    set sysroot /mnt/sshfs/
end

