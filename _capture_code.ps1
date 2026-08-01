param([int]$Line, [string]$Out)
$code = "C:\Users\USER\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"
& $code --goto "F:\outputs\sqat-skillbank\selenium_suite.py:$Line`:1" | Out-Null
Start-Sleep -Seconds 7
powershell -ExecutionPolicy Bypass -File "F:\outputs\sqat-skillbank\capture_window.ps1" -TitleMatch "Visual Studio Code" -Out $Out -Delay 2
