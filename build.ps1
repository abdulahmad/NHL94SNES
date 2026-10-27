# Windows build: runs node tools\build.js (check the ROM, extract, put the real names back, assemble with asar, verify).
Set-Location $PSScriptRoot
node tools/build.js @args
exit $LASTEXITCODE
