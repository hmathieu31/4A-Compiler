$allTestsPassed = $true

if (Test-Path -Path .\tests\tests_log.log) {
    Remove-Item .\tests\tests_log.log
}
Write-Output "   --- Tests OK ---   " | Out-File .\tests\tests_log.log -Append
foreach ($item in Get-ChildItem .\tests\tests_ok\) {
    $nameOfTest = $item.Name;
    Write-Output "`n--- Test --- ${nameOfTest} ---" | Out-File -Append -FilePath .\tests\tests_log.log
    Get-Content $item | .\bin\comp.exe 2>&1 | Out-File -Append -FilePath .\tests\tests_log.log
    $execSuccessful = $?
    $test = "Test ok - " + $nameOfTest
    if ($execSuccessful -eq $true) {
        Write-Output -InputObject $test" - passed successfully ✅"
    }
    else {
        Write-Output -InputObject $test" - failed ❌"
        $allTestsPassed = $false
    }
}

Write-Output "   --- Tests KO ---   " | Out-File .\tests\tests_log.log -Append
foreach ($item in Get-ChildItem .\tests\tests_ko) {
    $nameOfTest = $item.Name;
    Write-Output "`n--- Test --- ${nameOfTest} ---" | Out-File -Append -FilePath .\tests\tests_log.log
    Get-Content $item | .\bin\comp.exe 2>&1 | Out-File -Append -FilePath .\tests\tests_log.log
    $execSuccessful = $?
    $test = "Test ko - " + $nameOfTest
    if ($execSuccessful -eq $false) {
        Write-Output -InputObject $test" - passed successfully ✅"
    }
    else {
        Write-Output -InputObject $test" - failed ❌"
        $allTestsPassed = $false
    }
}

Write-Output " `n---------------------------------- "
Write-Output " --- Tests summary ---"
if ($allTestsPassed -eq $true) {
    Write-Output "All tests passed successfully ✅"
}
else {
    Write-Output "Some tests failed ❌"
}
