nmap <F5>  :call vimspector#Continue()<CR>
nmap <F3>  :call vimspector#Reset()<CR>
nmap <F4>  :call vimspector#Restart()<CR>
nmap <F6>  :call vimspector#Pause()<CR>
nmap <F9>  :call vimspector#ToggleBreakpoint()<CR>
nmap <F8>  :call vimspector#GoToCurrentLine()<CR>
nmap <F10> :call vimspector#StepOver()<CR>
nmap <F11> :call vimspector#StepInto()<CR>
nmap <F12> :call vimspector#StepOut()<CR>

let mi_mode = has('mac')?"lldb":"gdb"
let g:vimspector_configurations = {
            \  "default": {
            \    "adapter": "vscode-cpptools",
            \    "configuration": {
            \      "request": "launch",
            \      "program": "${cwd}/build/bin/${EXECUTABLE_NAME:${fileBasenameNoExtension\\}}",
            \      "cwd": "${cwd}/build",
            \      "args": ["*${CommandLineArgs}"],
            \      "externalConsole": has('mac'),
            \      "stopAtEntry": v:true,
            \      "stopOnEntry": v:true,
            \      "MIMode": mi_mode
            \    },
            \    "breakpoints": {
            \      "exception": {
            \        "all": "",
            \        "cpp_catch": "",
            \        "cpp_throw": "",
            \        "objc_catch": "",
            \        "objc_throw": "",
            \        "swift_catch": "",
            \        "swift_throw": ""
            \      }
            \    },
            \    "default": v:true
            \  }
            \}
