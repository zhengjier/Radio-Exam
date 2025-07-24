[CmdletBinding()]
Param()

$qs = Get-Content "$PSScriptRoot\A.txt"

$Questions = @{}

foreach ($line in $qs) {
    if (!$line) {
        Clear-Variable Question
        Clear-Variable No
        Clear-Variable Title
        Clear-Variable Answers
    }
    if ($line -match "\[I\].+") {
        $No = $line.substring(3)
        $Answers = @{}
        $Question = @{}
        # $no
    }
    if ($line -match "\[Q\].+") {
        $Title = $line.substring(3)
        $Question.Title = $Title
        # $Question
    }
    if ($line -match "^\[[A-G]\].+$") {
        $key = $line.substring(1,1)
        $Answers.$key = $line.substring(3)
        # $Answers
    }
    if ($line -eq "[P]") {
        # $Answers
        $Question.Answers = $Answers
        $Questions.$No = $Question
        # $Question
    }
}

$Questions | ConvertTo-Json | Out-File "$PSScriptRoot\A.json"