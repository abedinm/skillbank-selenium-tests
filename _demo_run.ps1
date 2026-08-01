$Host.UI.RawUI.WindowTitle = "SQAT - Selenium test run"
try { $Host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size(120, 400) } catch {}
try { $Host.UI.RawUI.WindowSize  = New-Object Management.Automation.Host.Size(120, 46) } catch {}
Set-Location F:\outputs\sqat-skillbank
Clear-Host
$env:SB_HEADED = "1"
Write-Host "PS F:\outputs\sqat-skillbank> python reset_db.py"
python reset_db.py
Write-Host ""
Write-Host "PS F:\outputs\sqat-skillbank> python selenium_suite.py"
python selenium_suite.py
Write-Host ""
Write-Host "PS F:\outputs\sqat-skillbank> " -NoNewline
