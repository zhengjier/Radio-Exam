[CmdletBinding()]
Param(
    $Mode = 1,
    $ReviewMode = 1,
    $NumberOfQuestions = 30
    # [switch]$Bypass
)

function ConvertTo-Hashtable ($obj) {
    $hashtable = @{}
    $obj.PSObject.Properties | ForEach-Object {
        $hashtable[$_.Name] = $_.Value
    }
    return $hashtable
}

#region Menu
$ExamExist = 0
$MockExamPath = "$PSScriptRoot\Backend\MockExam.json"
Write-Verbose "Loading the mock exam file"
if (Test-Path $MockExamPath) {
    # $MockExam = . "$PSScriptRoot\Backend\Create-MockExam.ps1" -Mode $Mode -NumberOfQuestions $NumberOfQuestions
    $ExamExist = 1
    $MockExam = ConvertTo-Hashtable (Get-Content $MockExamPath -Raw | ConvertFrom-Json)
}

$Option = -1
if ($ExamExist -eq 1 -and $MockExam.Status -eq 'Done') {
    Write-Host "There is a completed mock exam, what do you want"
    Write-Host "0. Review"
}
elseif ($ExamExist -eq 1 -and $MockExam.Status -ne 'Done') {
    Write-Host "There is an incompleted mock exam, what do you want"
    Write-Host "0. Continue"
}
Write-Host "1. Start a new one (Normal)"
Write-Host "2. Start a new one (Instant Review)"
# Write-Host "3. Start a new one (All Questions)"

while ($Option -notmatch "^[0-2]{1}$") {$Option = Read-Host "Please select"}
if ($Option -eq 0) {
    if ($MockExam.Status -eq 'Done') {
        . "$PSScriptRoot\Backend\Get-ExamReview.ps1" -MockExam $MockExam
    }
    else {
        . "$PSScriptRoot\Backend\Start-MockExam.ps1" -MockExam $MockExam
    }
}
# Start a new one (Normal)
if ($Option -eq 1) {
    $NumberQInput = 0
    while (($NumberQInput -eq 0 -or $NumberQInput -ne "") -and ($NumberQInput -notmatch "^(\d{1}|\d{2}|\d{3})$" -or $NumberQInput -le 0 -or $NumberQInput -gt 365)) {
        $NumberQInput = Read-Host "Please input the number of questions (up to 365, default is 30)"
    }
    if ($NumberQInput -eq "") {
        $NumberQInput = 30
    }
    if ($ExamExist -eq 1) {
        Remove-Item "$PSScriptRoot\Backend\MockExam.json"
    }
    . "$PSScriptRoot\Backend\Create-MockExam.ps1" -NumberOfQuestions $NumberQInput
    $MockExam = ConvertTo-Hashtable (Get-Content $MockExamPath -Raw | ConvertFrom-Json)
    . "$PSScriptRoot\Backend\Start-MockExam.ps1" -MockExam $MockExam
}
# Start a new one (Instant Review)
if ($Option -eq 2) {
    $NumberQInput = 0
    while (($NumberQInput -eq 0 -or $NumberQInput -ne "") -and ($NumberQInput -notmatch "^(\d{1}|\d{2}|\d{3})$" -or $NumberQInput -le 0 -or $NumberQInput -gt 365)) {
        $NumberQInput = Read-Host "Please input the number of questions (up to 365, default is 30)"
    }
    if ($NumberQInput -eq "") {
        $NumberQInput = 30
    }
    if ($ExamExist -eq 1) {
        Remove-Item "$PSScriptRoot\Backend\MockExam.json"
    }
    . "$PSScriptRoot\Backend\Create-MockExam.ps1" -Mode 2 -NumberOfQuestions $NumberQInput
    $MockExam = ConvertTo-Hashtable (Get-Content $MockExamPath -Raw | ConvertFrom-Json)
    . "$PSScriptRoot\Backend\Start-MockExam.ps1" -MockExam $MockExam
}
# Start a new one (All Questions)
if ($Option -eq 3) {
    Remove-Item "$PSScriptRoot\Backend\MockExam.json"
    . "$PSScriptRoot\Backend\Create-MockExam.ps1" -NumberOfQuestions 365
    $MockExam = ConvertTo-Hashtable (Get-Content $MockExamPath -Raw | ConvertFrom-Json)
    . "$PSScriptRoot\Backend\Start-MockExam.ps1" -MockExam $MockExam
}

#endregion