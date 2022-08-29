function New-S1Site {
    <#
    .NOTES
        Author:			Michael Stafford <mstafford13@email.davenport.edu>
        Date-Modified:	2022-08-25 15:23:54
    .SYNOPSIS
        Adds a new site in SentinelOne
        
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [parameter(Mandatory=$True)]
        [String]
        $SiteName,

        [parameter(Mandatory=$True)]
        [String]
        $SiteType,

        [parameter(Mandatory=$True)]
        [boolean]
        $UnlimitedLicenses,

        [parameter(Mandatory=$True)]
        [boolean]
        $UnlimitedExpiration,

        [parameter(Mandatory=$True)]
        [boolean]
        $IsDefault,

        [parameter(Mandatory=$True)]
        [boolean]
        $Inherits,

        [parameter(Mandatory=$True)]
        [String]
        $AccountName,

        [parameter(Mandatory=$True)]
        [String]
        $AccountId,

        [parameter(Mandatory=$False)]
        [String]
        $Description,

        [parameter(Mandatory=$True)]
        [String]
        $SKUName,

        [parameter(Mandatory=$True)]
        [String]
        $TotalAgentsName,

        [parameter(Mandatory=$True)]
        [Int]
        $Count
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog += " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/sites"


        $Surfaces = @(@{
            name = $TotalAgentsName
            count = $Count
          })
          
          $Bundles = @(@{
            name = $SKUName
            surfaces = $Surfaces
          })
          
          $Licenses = @{
            bundles = $Bundles
          }
        

        $Body = @{
            data = @{
                name = $SiteName
                siteType = $SiteType
                unlimitedLicenses = $UnlimitedLicenses
                unlimitedExpiration = $UnlimitedExpiration
                isDefault = $IsDefault
                inherits = $Inherits
                accountName = $AccountName
                accountId = $AccountId
                description = $Description
                licenses = $Licenses
            }
        }

        $Response = Invoke-S1Query -URI $URI -Method POST -Body ($Body | ConvertTo-Json -Depth 99) -ContentType "application/json"
        Write-Output $Response.data
    }
}