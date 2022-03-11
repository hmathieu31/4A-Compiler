foreach ($item in Get-ChildItem .\tests\tests_ok\) {
    Get-Content $item | .\bin\comp.exe 2>&1 | Out-Null
    $test = "Test ok - " + $item.Name
    if ($?) {
        Write-Output -InputObject $test" - passed successfully ✅"
    } else {
        Write-Output -InputObject $test" - failed ❌"
    }
}
foreach ($item in Get-ChildItem .\tests\tests_ko) {
    Get-Content $item | .\bin\comp.exe 2>&1 | Out-Null
    $test = "Test ko - " + $item.Name
    if ($?) {
        Write-Output -InputObject $test" - passed successfully ✅"
    } else {
        Write-Output -InputObject $test" - failed ❌"
    }
}
