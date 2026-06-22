#Requires AutoHotkey v2.0

; 仅在 Windows Terminal 窗口激活时生效
#HotIf WinActive("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")

global tmux_prefix := false
global copy_mode := false
global selecting := false
global visual_line := false
global line_dir := 0 ; 0: 未定, 1: 向下选择 (锚点在行首), -1: 向上选择 (锚点在行尾)
global ih_copy := ""

; 拦截 Ctrl + a 进入前缀状态
^a::
{
    global tmux_prefix := true
    ; 设置 2 秒超时，超时未输入其他键则自动清除前缀状态
    SetTimer(ClearPrefix, -2000)
}

; 检测当前 Windows Terminal 标签页是否正在运行 Vim / Neovim
IsVimActive() {
    try {
        title := WinGetTitle("A")
        ; 使用正则精准匹配：
        ; 1. 标题含有 " - NVIM" 或 " - VIM" (Vim 默认的窗口标题后缀)
        ; 2. 标题以 "nvim" 或 "vim" 开头 (如独立运行或带参数启动)
        ; 避免匹配到包含 ".vim" 或 "nvim" 的目录路径
        return RegExMatch(title, "i)( - n?vim|^\s*n?vim(\s|$))")
    } catch {
        return false
    }
}

; ==================== 直接快捷键（仅在非 Vim/Neovim 环境下，且非复制模式时生效） ====================
#HotIf WinActive("ahk_class CASCADIA_HOSTING_WINDOW_CLASS") and not IsVimActive() and not tmux_prefix and not copy_mode

; Ctrl + h/j/k/l 直接切换 WT 分屏焦点
; (利用 {Blind} 维持 Ctrl 物理按下状态，发送 Ctrl + Shift + Alt + 方向键组合)
; 使用方向键配合修饰键可以完全避免任何字母快捷键冲突或显卡/系统热键冲突。
^h::Send("{Blind}+!{Left}")
^j::Send("{Blind}+!{Down}")
^k::Send("{Blind}+!{Up}")
^l::Send("{Blind}+!{Right}")


; ==================== 需要 Ctrl + a 前缀的快捷键（WT 全局生效） ====================
#HotIf WinActive("ahk_class CASCADIA_HOSTING_WINDOW_CLASS") and tmux_prefix

; c -> 新建标签页 (基于您的 settings.json 配置: Ctrl + Shift + C)
c::
{
    global tmux_prefix := false
    SetTimer(ClearPrefix, 0)
    Send("^+c")
}

; v -> 垂直分屏 / 左右分屏 (基于您的 settings.json 配置: Ctrl + Alt + V)
v::
{
    global tmux_prefix := false
    SetTimer(ClearPrefix, 0)
    Send("^!v")
}

; s -> 水平分屏 / 上下分屏 (基于您的 settings.json 配置: Ctrl + Alt + S)
s::
{
    global tmux_prefix := false
    SetTimer(ClearPrefix, 0)
    Send("^!s")
}

; x -> 关闭当前分屏 (WT 默认: Ctrl + Shift + W)
x::
{
    global tmux_prefix := false
    SetTimer(ClearPrefix, 0)
    Send("^+w")
}

; z -> 全屏/取消全屏当前分屏 (已在 settings.json 中为您配置绑定: Ctrl + Alt + Z)
z::
{
    global tmux_prefix := false
    SetTimer(ClearPrefix, 0)
    Send("^!z")
}

; Ctrl + v -> 进入复制/选择模式 (触发 WT 标记模式)
^v::
{
    global tmux_prefix := false
    SetTimer(ClearPrefix, 0)
    StartCopyMode()
}

; Ctrl + h -> 切换到上一个标签页 (WT 默认: Ctrl + Shift + Tab)
; 采用 tmux -r (repeat) 机制：切换后不关闭前缀模式，而是刷新 1.5 秒的重复等待定时器
^h::
{
    SetTimer(ClearPrefix, -1500)
    Send("{Blind}+{Tab}")
}

; Ctrl + l -> 切换到下一个标签页 (WT 默认: Ctrl + Tab)
; 采用 tmux -r (repeat) 机制：切换后不关闭前缀模式，而是刷新 1.5 秒的重复等待定时器
^l::
{
    SetTimer(ClearPrefix, -1500)
    Send("{Blind}{Tab}")
}

; 双击 Ctrl + a 发送原本的 Ctrl + a
^a::
{
    global tmux_prefix := false
    SetTimer(ClearPrefix, 0)
    Send("^a")
}

; Esc -> 取消前缀
Esc::
{
    global tmux_prefix := false
    SetTimer(ClearPrefix, 0)
}


; ==================== Windows Terminal 复制模式 (Vim 键位选择) ====================
#HotIf WinActive("ahk_class CASCADIA_HOSTING_WINDOW_CLASS") and copy_mode

; h/l 移动 (根据是否处于 v/V 选区状态，自动判断是否带 Shift)
h::Send(selecting ? "+{Left}" : "{Left}")
l::Send(selecting ? "+{Right}" : "{Right}")

; 0/$ 移动到行首/行尾
0::Send(selecting ? "+{Home}" : "{Home}")
$::Send(selecting ? "+{End}" : "{End}")

; w/b 按单词移动 (前移/后移)
w::Send(selecting ? "^+{Right}" : "^{Right}")
b::Send(selecting ? "^+{Left}" : "^{Left}")

; j/k 移动 (行选择模式下动态维护锚点和方向，保证起始行始终被完整选中)
j::
{
    if (visual_line) {
        if (line_dir == 0) {
            global line_dir := 1 ; 向下选择 (当前行首为固定锚点，向下一行并选择到行尾)
            Send("+{Down}+{End}")
        } else if (line_dir == 1) {
            Send("+{Down}+{End}")
        } else if (line_dir == -1) {
            Send("+{Down}+{Home}") ; 收缩向上选择的区域，对齐到行首
        }
    } else if (selecting) {
        Send("+{Down}")
    } else {
        Send("{Down}")
    }
}

k::
{
    if (visual_line) {
        if (line_dir == 0) {
            ; 向上选择时，当前行尾为固定锚点。
            ; 必须先发送端点切换 (^+!o) 将光标切到当前行首，再向上选择至上一行的行首。
            Send("^+!o")
            global line_dir := -1
            Send("+{Up}+{Home}")
        } else if (line_dir == -1) {
            Send("+{Up}+{Home}")
        } else if (line_dir == 1) {
            Send("+{Up}+{End}") ; 收缩向下选择的区域，对齐到行尾
        }
    } else if (selecting) {
        Send("+{Up}")
    } else {
        Send("{Up}")
    }
}

; u / Ctrl+u 翻页 
*u::
{
    if (DllCall("GetAsyncKeyState", "Int", 17) & 0x8000) {
        Send("{Ctrl Up}")
        Send(selecting ? "+{PgUp}" : "{PgUp}")
        Send("{Ctrl Down}")
    }
}

; d / Ctrl+d 翻页
*d::
{
    if (DllCall("GetAsyncKeyState", "Int", 17) & 0x8000) {
        Send("{Ctrl Up}")
        Send(selecting ? "+{PgDn}" : "{PgDn}")
        Send("{Ctrl Down}")
    }
}

; v 进入/退出字符选择模式
v::
{
    global selecting := !selecting
    global visual_line := false
    global line_dir := 0
}

; V (Shift + v) 进入行选择模式 (发送 Home 键到行首，开启选择并选中当前整行)
+v::
{
    global selecting := true
    global visual_line := true
    global line_dir := 0
    Send("{Home}+{End}")
}

; o 反向选择 (交换选择起点和终点，基于 WT 的 switchSelectionEndpoint 动作)
o::
{
    if (selecting) {
        if (visual_line) {
            global line_dir := -line_dir
        }
        Send("^+!o")
    }
}

; y 复制选区并退出 (WT 标记模式下按 Enter 即可复制)
y::
{
    StopCopyMode(false)
    Send("{Enter}")
}

; i / Esc 退出复制模式 (仅允许这二者退出)
i::
Esc::
{
    StopCopyMode(true)
}

; 鼠标点击时，自动退出 AHK 的复制状态
~LButton::
{
    StopCopyMode(false)
}

#HotIf ; 重置条件过滤

; ==================== 复制模式辅助管理函数 ====================

StartCopyMode() {
    global copy_mode := true
    global selecting := false
    global visual_line := false
    global line_dir := 0
    global ih_copy := InputHook()     ; 不传 "V" 参数，默认拦截输入
    ih_copy.MinSendLevel := 1         ; 忽略脚本自身 Send 发出的虚拟按键
    ih_copy.KeyOpt("{All}", "S")      ; 默认拦截所有按键，防止其它按键传递给 Windows Terminal 导致其退出标记模式
    ; 显式允许方向键、翻页键、Home/End 等不需要 AHK 自行映射的原生导航按键透传给 Windows Terminal
    ih_copy.KeyOpt("{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}", "-S")
    ; 必须放行所有修饰键（Ctrl, Shift, Alt, Win），否则组合键和 GetKeyState 判断会因修饰键被拦截而失效
    ih_copy.KeyOpt("{LCtrl}{RCtrl}{LShift}{RShift}{LAlt}{RAlt}{LWin}{RWin}", "-S")
    ih_copy.Start()
    Send("^+m") ; 进入 Windows Terminal 标记模式
}

StopCopyMode(sendEsc := true) {
    global copy_mode := false
    global selecting := false
    global visual_line := false
    global line_dir := 0
    if (Type(ih_copy) == "InputHook") {
        ih_copy.Stop()
    }
    if (sendEsc) {
        Send("{Esc}")
    }
}

ClearPrefix() {
    global tmux_prefix := false
}
