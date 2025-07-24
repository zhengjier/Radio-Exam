Param (
    $MockExam,
    [ValidateSet(1, 2)]
    $ReviewMode = 1
)

if ($ReviewMode -eq 1) {
    $NumberOfQuestions = 0
    foreach ($Q in $MockExam.MockQs.psobject.Properties.name) {
        $NumberOfQuestions ++
        clear
        if ($MockExam.MockQs.$Q.CorrectAns -ne $MockExam.MockQs.$Q.Selected) {
            $SelectedAnsKey = $MockExam.MockQs.$Q.Selected
            $CorrectAnsKey = $MockExam.MockQs.$Q.CorrectAns
            Write-Host "No.$NumberOfQuestions`: [$Q]$($MockExam.MockQs.$Q.Title)"
            $MockExam.MockQs.$Q.Answers.psobject.Properties | sort Name | % {
                if ($_.Name -eq $SelectedAnsKey -and $_.Name -ne $CorrectAnsKey) {
                    Write-Host "$($_.Name). $($_.Value)" -ForegroundColor White -BackgroundColor Red
                }
                elseif ($_.Name -eq $CorrectAnsKey) {
                    Write-Host "$($_.Name). $($_.Value)" -ForegroundColor White -BackgroundColor Green
                }
                else {
                    Write-Host "$($_.Name). $($_.Value)"
                }
            }
            # Write-Host "Selected: $SelectedAnsKey"
            Write-Host "Correct Answer: $CorrectAnsKey"
            Read-Host "Press Enter to the next one"
        }
    }
}
