foreach ($item in Get-ChildItem .\tests\tests_ok\) {
    $eval = Get-Content $item | .\bin\comp.exe 2>&1
    $test = "Test ok - " + $item.Name
    <#
     # Clumsy way to detect the errors during execution, but the stderr was not redirected properly to Powershell.
     # If there are no errors, $eval = combinaison of stdoutput and stderror is simply stdoutput --> a string
     # If "errors are raised", $eval becomes an object containing both std
     # Will have to be perfected when the compiler will but functional as is for now
     #>
    $cond = $eval.GetType().Name -eq "String";
    if ($cond) {
        Write-Output -InputObject $test" - passed successfully"
    } else {
        Write-Output -InputObject $test" - failed"
    }
}
foreach ($item in Get-ChildItem .\tests\tests_ko) {
    $eval = Get-Content $item | .\bin\comp.exe 2>&1
    $test = "Test ko - " + $item.Name
    $cond = $eval.GetType().Name -eq "String";
    if ($cond -eq $false) {
        Write-Output -InputObject $test" - passed successfully"
    } else {
        Write-Output -InputObject $test" - failed"
    }
}
