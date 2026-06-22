#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; 1. 自动提升管理员权限并绕过 UAC 弹窗 (Run as Administrator via Task Scheduler)
; ==============================================================================
RunAsTask()

RunAsTask() {
    local TaskName := "autohotkey"

    if A_IsAdmin {
        try {
            TaskService := ComObject("Schedule.Service")
            TaskService.Connect()
            Folder := TaskService.GetFolder("\")
            
            TaskDefinition := TaskService.NewTask(0)
            Principal := TaskDefinition.Principal
            Principal.RunLevel := 1 ; Highest Privileges
            
            Settings := TaskDefinition.Settings
            Settings.Enabled := true
            Settings.DisallowStartIfOnBatteries := false
            Settings.StopIfGoingOnBatteries := false
            Settings.ExecutionTimeLimit := "PT0S" ; 运行时间无限限制
            
            Actions := TaskDefinition.Actions
            Action := Actions.Create(0) ; ExecAction
            Action.Path := A_AhkPath
            Action.Arguments := '"' A_ScriptFullPath '"'
            
            Folder.RegisterTaskDefinition(TaskName, TaskDefinition, 6, , , 3)
        } catch as e {
            try FileDelete(A_Temp "\ahk_error.txt")
            FileAppend("Error: " e.Message "`nLine: " e.Line "`nWhat: " e.What "`nName: " TaskName "`n", A_Temp "\ahk_error.txt")
        }
    } else {
        try {
            TaskService := ComObject("Schedule.Service")
            TaskService.Connect()
            Folder := TaskService.GetFolder("\")
            Task := Folder.GetTask(TaskName)
            Task.Run("")
            ExitApp()
        } catch {
            ; 如果计划任务不存在，则触发一次传统的 UAC 提权来注册该任务
            try {
                Run('*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"')
                ExitApp()
            } catch {
                MsgBox("无法以管理员权限运行。在某些高权限窗口中，快捷键可能无法生效。", "警告", 48)
            }
        }
    }
}

; 自定义托盘图标和悬停提示
TraySetIcon("shell32.dll", 16)
A_IconTip := "AHK 主控制中心"

; ==============================================================================
; 2. 模块化导入
; 将模块文件放在 modules 子目录下，避免 Windows 开机自启时把它们当成独立脚本全部运行。
; ==============================================================================
#Include %A_AppData%\ahk\wt_tmux.ahk

; ==============================================================================
; 3. 全局管理快捷键 (开发者快捷键)
; ==============================================================================

; Ctrl + Alt + Shift + R -> 快速重新加载脚本
^!+r:: {
    ToolTip("正在重新加载 AHK 脚本...")
    SetTimer(() => ToolTip(), -1500)
    Sleep(200)
    Reload()
}

; Ctrl + Alt + Shift + E -> 在 VS Code 中打开 AHK 脚本文件夹
^!+e:: {
    try {
        Run("code `"" A_AppData "\ahk`"")
    } catch {
        Run("explorer.exe `"" A_AppData "\ahk`"")
    }
}
