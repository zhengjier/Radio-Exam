[CmdletBinding()]
Param(
    $NumberOfQuestions = 30,
    $Mode = 1
)

$QLib = Get-Content "$PSScriptRoot\A.json" -Raw | ConvertFrom-Json

$QTitles = $QLib.PSObject.Properties.Name

$RandomOrder = (0..$($QTitles.Count-1)) | sort-object {get-random}

$MockExam = @{}
$MockQs = @{}

for ($i = 0; $i -lt $NumberOfQuestions; $i++) {
    try {
        $QTitle = $QTitles[$RandomOrder[$i]]
        $MockQs.$QTitle = @{}
        # $MockQs.$QTitle.Answers = $QLib.$QTitle.Answers
        # $QTitle
        $MockQs.$QTitle.Title = $QLib.$QTitle.Title
    
        $Answers = $QLib.$QTitle.Answers
        $CorrentAns = $Answers.A
    
        $NumberOfAns = $Qlib.$qTitle.Answers.psobject.Properties.name.count
        $AnsRandomOrder = (0..$($NumberOfAns-1)) | sort-object {get-random}
    
        $NewAns = @{}
        for ($j = 0; $j -lt $NumberOfAns; $j++) {
            $Key = ([char](65 + $j)).tostring()
            $OriginKey = ([char](65 + $AnsRandomOrder[$j])).tostring()
            $NewAns.$Key = $QLib.$QTitle.Answers.$OriginKey
            if ($AnsRandomOrder[$j] -eq 0) {
                $CorrentAnsKey = $Key
            }
            $MockQs.$QTitle.CorrectAns = $CorrentAnsKey
        }
    
        $MockQS.$QTitle.Answers = $NewAns
    }
    catch {
        # $QTitle
    }
}

$MockExam.MockQs = $MockQs
$MockExam.Status = "New"
$MockExam.LastAnsweredQuestion = ""
$MockExam.StartTime = Get-Date -Format "MM/dd/yyyy hh:mm:ss"
$MockExam.Score = -1
$MockExam.Mode = $Mode

$MockExam | ConvertTo-Json -Depth 10 | Out-File "$PSScriptRoot\MockExam.json"

# return $MockExam