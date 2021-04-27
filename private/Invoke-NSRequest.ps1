<#
.SYNOPSIS
    Powershell management wrapper for the Netsapiens platform
.DESCRIPTION
    Takes a JSON array and sends the request to the Netapiens platform. Returns the response.
.EXAMPLE
    Invoke-NSRequest -request $request
.LINK
    https://github.com/oitapps
#>
Function Invoke-NSRequest {

    ## Helper function to place API calls
    ## Scopes: Any
    param (
        [Parameter(Mandatory = $true)][Hashtable]$request,
        [Parameter(Mandatory = $false)][String]$type = "get"
    )
        
    # Set platform vars
    if(!$global:nsFQDN){
        $global:nsFQDN = Read-Host "Netsapiens FQDN"
    }

    # NS token expires in 1 hour. Check if token is still valid. If not, request a new one
    if ((!$global:nsAPIToken) -or ((get-date) -gt $global:nsAPIToken.expiration)) {
        Get-NSToken
    }

    # Add format descriptor in case it's missing
    if (!$request.format) { $request.add('format', 'json') }

    # Set headers
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", 'Bearer ' + $global:nsAPIToken.access_token)

    # Set request URL
    $requrl = "https://" + $global:nsFQDN + "/ns-api/"

    $response = Invoke-RestMethod $requrl -Headers $headers -Method $type -Body $request
    #add property for http response code
    #add propert for error
    
    return $response
}