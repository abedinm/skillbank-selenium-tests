$Host.UI.RawUI.WindowTitle = "SQAT - Database verification"
try { $Host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size(120, 400) } catch {}
try { $Host.UI.RawUI.WindowSize  = New-Object Management.Automation.Host.Size(120, 34) } catch {}
Set-Location F:\outputs\sqat-skillbank
Clear-Host
$mysql = "C:\xampp\mysql\bin\mysql.exe"
Write-Host "State of the database after the automated run (TC_ses-04 credit transfer):"
Write-Host ""
Write-Host "> mysql -u root -e ""SELECT id,name,email,role,credits FROM skillbank.users;"""
& $mysql -u root -e "SELECT id,name,email,role,credits FROM skillbank.users;"
Write-Host ""
Write-Host "> mysql -u root -e ""SELECT from_user,to_user,session_id,credits FROM skillbank.transactions;"""
& $mysql -u root -e "SELECT from_user,to_user,session_id,credits FROM skillbank.transactions;"
Write-Host ""
Write-Host "> mysql -u root -e ""SELECT id,learner_id,teacher_id,status FROM skillbank.sessions;"""
& $mysql -u root -e "SELECT id,learner_id,teacher_id,status FROM skillbank.sessions;"
Write-Host ""
Write-Host "PS F:\outputs\sqat-skillbank> " -NoNewline
