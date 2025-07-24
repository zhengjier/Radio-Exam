Param (
    $Question,
    $No,
    $Title
)
clear
$SelectedAnsKey = $Question.Selected
$CorrectAnsKey = $Question.CorrectAns
Write-Host "No.$No`: [$Title]$($Question.Title)"
$Question.Answers.psobject.Properties | sort Name | % {
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