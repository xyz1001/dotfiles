#Requires AutoHotkey v2.0
#include OCR.ahk

; ==============================================================================
; 验证码自动复制模块 (Auto-Copy Verification Code Module)
; 使用 WinEventHook 监听所有窗口显示事件，针对飞书弹窗集成 WinRT OCR (光学字符识别) 识别
; ==============================================================================

processed_hwnds := Map()

; 注册 WinEventHook 监听所有窗口的显示事件 EVENT_OBJECT_SHOW (0x8002)
; 这比 ShellHook 更加健壮，能捕捉到所有类型的自定义弹窗、非任务栏窗口、对话框等
Hook := DllCall("SetWinEventHook"
    , "UInt", 0x8002 ; eventMin
    , "UInt", 0x8002 ; eventMax
    , "Ptr", 0 ; hModuleHook
    , "Ptr", CallbackCreate(WinEventProc, "F", 7) ; lpfnWinEventProc (7 parameters)
    , "UInt", 0 ; idProcess
    , "UInt", 0 ; idThread
    , "UInt", 0) ; dwFlags (WINEVENT_OUTOFCONTEXT = 0)

WinEventProc(hHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
    if (idObject = 0) { ; OBJID_WINDOW 代表窗口对象本身，排除控件
        ; 异步处理，避免阻塞系统的事件队列
        SetTimer(() => ProcessNewWindow(hwnd), -100)
    }
}

ProcessNewWindow(hwnd) {
    global processed_hwnds
    
    ; 1. 过滤已处理的 HWND
    if (processed_hwnds.Has(hwnd))
        return
        
    ; 2. 检查窗口是否仍然存在并且可见
    if (!WinExist(hwnd) || !DllCall("IsWindowVisible", "Ptr", hwnd))
        return
        
    try {
        title := WinGetTitle(hwnd)
        className := WinGetClass(hwnd)
        processName := WinGetProcessName(hwnd)
        WinGetPos(&x, &y, &w, &h, hwnd)
    } catch {
        return
    }
    
    ; 3. 过滤常见的无意义系统窗口和输入法窗口以减少日志噪音
    if (title = "" && (className = "IME" || className = "MSCTFIME UI" || className = "tooltips_class32" || className = "CabinetWClass"))
        return
        
    processed_hwnds[hwnd] := true
    LogMessage("发现新窗口: '" title "' | 类名: '" className "' | 进程: '" processName "' | HWND: " hwnd " | 尺寸: " w "x" h " | 位置: " x "," y)
    
    ; 识别是否是飞书的自定义验证码弹窗 (Feishu.exe, Chrome_WidgetWin_1, 无标题)
    ; 飞书验证码弹窗大小非常固定 (逻辑像素 w: 540, h: 120)，我们放宽范围限制以防不同 DPI 缩放影响
    isFeishuPopup := (processName = "Feishu.exe" && className = "Chrome_WidgetWin_1" && title = "" && w >= 400 && w <= 700 && h >= 80 && h <= 200)
    
    ; 4. 延迟重试循环：有些窗口渲染内容需要时间，我们在 600ms 内重试 3 次扫描
    loop 3 {
        Sleep(200)
        
        if (!WinExist(hwnd))
            return
            
        fullText := ""
        if (isFeishuPopup) {
            ; 飞书弹窗直接通过 native OCR 进行光学文字识别
            fullText := RunOCR(hwnd)
        } else {
            ; 其它窗口使用常规的文本提取
            try {
                standardText := WinGetText(hwnd)
            } catch {
                standardText := ""
            }
            uiaText := GetWindowTextUIA(hwnd)
            fullText := title "`n" className "`n" standardText "`n" uiaText
        }
        
        ; 如果成功提取到了有意义的文本，记录日志并解析
        if (fullText != "") {
            cleanedText := RegExReplace(fullText, "[\r\n]+", " | ")
            LogMessage(" -> 扫描文本 (尝试 " A_Index "): " cleanedText)
            
            code := FindVerificationCode(fullText)
            if (code != "") {
                ; 检查是否包含关键字以确认这是验证码窗口
                hasKeyword := false
                keywords := ["验证码", "验证", "code", "动态", "captcha", "security", "otp", "verification", "your", "login"]
                for kw in keywords {
                    if (InStr(fullText, kw)) {
                        hasKeyword := true
                        break
                    }
                }
                
                isVerified := false
                if (hasKeyword) {
                    isVerified := true
                } else if (isFeishuPopup && StrLen(code) = 6) {
                    ; 飞书弹窗中如果匹配到了 6 位数验证码，置信度极高，直接通过
                    isVerified := true
                } else {
                    ; 兜底策略：如果文本片段中存在完全等于该验证码的独立行/字段
                    loop parse, fullText, "`n|`r" {
                        if (Trim(A_LoopField) = code) {
                            isVerified := true
                            break
                        }
                    }
                }
                
                if (isVerified) {
                    CopyAndNotify(code, (isFeishuPopup ? "飞书验证码" : title))
                    return
                }
            }
        }
    }
}

FindVerificationCode(fullText) {
    pos := 1
    matches := []
    ; 找出所有 4-6 位数字
    while (pos := RegExMatch(fullText, "(?<!\d)\d{4,6}(?!\d)", &match, pos)) {
        matches.Push(match[0])
        pos += match.Len
    }
    
    if (matches.Length = 0)
        return ""
        
    ; 过滤掉可能是年份的 4 位数字（例如 1900-2100）
    validCodes := []
    for code in matches {
        if (StrLen(code) = 4) {
            num := Integer(code)
            if (num >= 1900 && num <= 2100) {
                continue
            }
        }
        validCodes.Push(code)
    }
    
    if (validCodes.Length > 0)
        return validCodes[1]
        
    return matches[1]
}

RunOCR(hwnd) {
    try {
        ; 使用 native OCR.FromWindow(hwnd) 进行光学字符识别
        ; 默认 mode=4 会使用 PrintWindow 并传入 PW_RENDERFULLCONTENT 标志，可完美截取 Electron/Chromium 硬件加速窗口
        result := OCR.FromWindow(hwnd)
        return result.Text
    } catch as e {
        LogMessage(" -> OCR 运行失败: " e.Message)
    }
    return ""
}

CopyAndNotify(code, title) {
    A_Clipboard := code
    TrayTip("已成功复制验证码: " code, "验证码自动复制", 1)
    LogMessage("★ SUCCESS ★ 成功复制验证码: " code " (来自窗口: " title ")")
}

LogMessage(msg) {
    try {
        logPath := A_Temp "\copy_verification_code.log"
        timeStr := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        FileAppend("[" timeStr "] " msg "`n", logPath, "UTF-8")
    }
}

GetWindowTextUIA(hwnd) {
    try {
        uia := ComObject("{ff48dba4-60ef-4201-aa87-54103eef594e}")
        element := uia.ElementFromHandle(hwnd)
        if (!element)
            return ""
            
        condition := uia.CreateTrueCondition()
        elements := element.FindAll(4, condition) ; TreeScope_Descendants = 4
        
        text := ""
        loop elements.Length {
            el := elements.GetElement(A_Index - 1)
            try {
                name := el.CurrentName
                if (name != "")
                    text .= name "`n"
            }
        }
        return text
    } catch {
        return ""
    }
}
