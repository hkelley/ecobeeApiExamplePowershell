﻿

param
(
	    [Parameter(Mandatory = $true)] [string] $TokenFile
	  , [Parameter(Mandatory = $false)] [string] $BaseUri = "https://api.ecobee.com/"
)

$tokenData = Get-Content -Path $TokenFile | ConvertFrom-Json
$accessToken= $tokenData.access_token

# TODO  refresh the token

#"grant_type=refresh_token&code=".concat(refreshToken).concat("&client_id=").concat(apiKey);

# get the thermostat data
#`{'selection':`{'selectionType':'registered','selectionMatch':'','includeRuntime':true`}`}

$uri = "$baseuri/1/thermostat?format=json&body=`{'selection':`{'selectionType':'registered','selectionMatch':'','includeRuntime':true,'includeSettings':true,'includeExtendedRuntime':true,'includeEvents':true,'includeDevice':true`}`}" 
$uri
try{
    $response = Invoke-WebRequest -Uri $uri -Headers @{"Authorization"="Bearer $accessToken"}
} catch {
    $Error[0]
    exit
}

$response

$jsonResponse = $response.Content  | ConvertFrom-Json

foreach($t in $jsonResponse.thermostatList)
{
    $t | fl *

    "runtime"
    $t.runtime | fl *

    "events"
    $t.events.count
    $t.events

}
