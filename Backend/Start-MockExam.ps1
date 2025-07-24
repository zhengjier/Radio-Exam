Param (
    $MockExam
)

try {
    $ExamMode = $MockExam.Mode
    $CurrentQNo = 0
    if ($MockExam.LastAnsweredQuestion) {
        $Cont = 0
    }
    else {
        $Cont = 1
    }
    foreach ($Q in $MockExam.MockQs.psobject.Properties.Name) {
        # $MockExam.MockQs.psobject.Properties
        # $Q
        # $MockExam.LastAnsweredQuestion
        $CurrentQNo ++
        if ($Cont -eq 0) {
            if ($MockExam.LastAnsweredQuestion -ne $Q) {
                continue
            }
            else {
                $Cont = 1
            }
        }
        if (($MockExam.LastAnsweredQuestion -ne $Q -and $Cont -eq 1)) {
            clear
            Write-Host "No.$CurrentQNo`: [$Q]$($MockExam.MockQs.$Q.Title)"
            $MockExam.MockQs.$Q.Answers.psobject.Properties | sort Name | % { Write-Host "$($_.Name). $($_.Value)" }
            $AnsInput = Read-Host "Please input your answer and press enter to continue"
            $NumberOfAns = $MockExam.MockQs.$Q.Answers.psobject.Properties.name.count
            $LastAnsKey = ([char](65 + $NumberOfAns - 1)).ToString()
            while ($AnsInput -notmatch "^[a-$($LastAnsKey.ToLower())A-$LastAnsKey]{1}$") {
                clear
                Write-Host "No.$CurrentQNo`: [$Q]$($MockExam.MockQs.$Q.Title)"
                $MockExam.MockQs.$Q.Answers.psobject.Properties | sort Name | % { Write-Host "$($_.Name). $($_.Value)" }
                $AnsInput = Read-Host "Please input your answer and press enter to continue"
            }
            
            $MockExam.MockQs.$Q | Add-Member -MemberType NoteProperty -Name Selected -Value $AnsInput.ToUpper()
            $MockExam.LastAnsweredQuestion = $Q
            $MockExam.Status = "InProgress"
            if ($ExamMode -eq 2) {
                . "$PSScriptRoot\Get-QuestionReview.ps1" -Question $MockExam.MockQs.$Q -No $CurrentQNo -Title $Q
            }
            clear
        }
        else {
            $Cont = 1
            continue
        }
    }
    $MockExam.Status = "Done"
    
    # Calculate result here
    $Score = 0
    $NumberOfQuestions = 0
    foreach ($Q in $MockExam.MockQs.psobject.Properties.Name) {
        $NumberOfQuestions ++
        if ($MockExam.MockQs.$Q.Selected -eq $MockExam.MockQs.$Q.CorrectAns) {
            $Score ++
        }
    }
    Write-Host "Final Score: $Score out of $NumberOfQuestions"
    Read-Host "Press Enter to review your exam"
    . "$PSScriptRoot\Get-ExamReview.ps1" -MockExam $MockExam
}
catch {

}
finally {
    $MockExam | ConvertTo-Json -Depth 10 | Out-File "$PSScriptRoot\MockExam.json"
}