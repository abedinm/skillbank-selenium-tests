$Host.UI.RawUI.WindowTitle = "SQAT - Installing Selenium"
try { $Host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size(120, 400) } catch {}
try { $Host.UI.RawUI.WindowSize  = New-Object Management.Automation.Host.Size(120, 32) } catch {}
Set-Location F:\outputs\sqat-skillbank
Clear-Host
Write-Host "PS F:\outputs\sqat-skillbank> python --version"
python --version
Write-Host ""
Write-Host "PS F:\outputs\sqat-skillbank> python -m pip install selenium"
python -m pip install selenium --no-input
Write-Host ""
Write-Host "PS F:\outputs\sqat-skillbank> python -m pip show selenium"
python -m pip show selenium
Write-Host ""
Write-Host "PS F:\outputs\sqat-skillbank> " -NoNewline
