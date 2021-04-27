<#
.SYNOPSIS
    Powershell management wrapper for the Netsapiens platform
.DESCRIPTION
    Upon running the script you will be prompted for your PBX credentials. Regardless of the functions in this script you will only be able to run commands available to your scope. I.e. Office Manager, Reseller, etc.
    You will also need to populate your config.json file and store it in the same folder as this script. Otherwise the script will not function. Contact OIT support for your client ID and secret.
.EXAMPLE
Get-LastBootTime -ComputerName localhost
.LINK
https://oit.co
#>

Function Get-NSToken() {


    # Get authentication credentials
    if (!$nsCreds) {
        $nsCreds = $host.ui.PromptForCredential("PBX Credentials", "Please enter your portal login and password.", "", "")
    }
    if(!$nsClientID){
        $nsClientID = Read-Host "Netsapiens Client ID"
    }
    if(!$nsClientSecret){
        $nsClientSecret = Read-Host "Netsapiens Client Secret"
    }
    
    $tokenURL = "https://" + $global:nsFQDN + "/ns-api/oauth2/token/?grant_type=password&client_id=" + $nsClientID + "&client_secret=" + $nsClientSecret + "&username=" + $nsCreds.UserName + "&password=" + $($nsCreds.getnetworkcredential().password)

    $global:nsAPIToken = Invoke-RestMethod $tokenURL
    $global:nsAPIToken | Add-Member NoteProperty -Name expiration -Value $(Get-Date).AddSeconds($global:nsAPIToken.expires_in) -force

}