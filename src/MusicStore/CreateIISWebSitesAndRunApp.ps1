param(
[Parameter(Mandatory=$true)]
[string]$publishedAppDir)

Import-Module WebAdministration

for($i=0; $i -lt 10; $i++)
{
    $appPool = New-Item IIS:\AppPools\"AppPool${i}"

    $appPoolName = $appPool.Name
    Set-ItemProperty -Path IIS:\AppPools\$appPoolName -Name managedRuntimeVersion -Value ''
    Write-Host "Created application pool '$appPoolName'"

    $port="808${i}"
    $bindings = @(
        @{protocol="http";bindingInformation=":${port}:"}
    )
    $webSite = New-Item IIS:\Sites\"Site${i}" -bindings $bindings -PhysicalPath $publishedAppDir
    $webSiteName = $webSite.Name
    Set-ItemProperty iis:\Sites\"${webSiteName}" -Name ApplicationPool -Value $appPool.Name
    Write-Host "Created website '$webSiteName'"

    Write-Host "Sleeping..."
    Start-Sleep -Seconds 3

    $url="http://localhost:${port}/"
    Write-Host "Making a request to the server at ${url}"
    $response = Invoke-WebRequest $url
    Write-Host "Response status code: " $response.StatusCode

    Write-Host "Stopping the website '${webSiteName}'"
    Stop-WebSite -Name $webSiteName

    Write-Host "Removing the website '${webSiteName}'"
    Remove-Item IIS:\Sites\$webSiteName -Recurse

    Write-Host "Removing the application pool '${appPoolName}'"
    Remove-Item IIS:\AppPools\$appPoolName -Recurse

    Write-Host "Dropping MusicStore database..."
    Import-Module SQLPS
    Invoke-SqlCmd -ServerInstance ".\SQLExpress" -Username "iis_login" -Password "Passw0rd" -InputFile .\DropMusicStore.sql

    Write-Host "Sleeping..." 
    Start-Sleep -Seconds 3
}