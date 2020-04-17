function Parse-FODError
{
    [CmdletBinding()]
    param (
    # The response object from FOD's API.
        [Parameter(
                Mandatory = $true,
                ValueFromPipeline = $true
        )]
        [Object]$ResponseObject,

    # The exception from Invoke-RestMethod, if available.
        [Exception]$Exception
    )

    Begin {
        $FODErrorData = @{
        # Messages are adapted from FOD API documentation

            invalid_client = @{
                Message = "The client secret provide as the password was incorrect"
                RecommendedAction = "Please re-enter the password or create a new API Key/Secret from the Fortify on Demand Portal"
            }

            invalid_grant = @{
                Message = "The resource owner password provided was incorrect"
                RecommendedAction = "Please re-enter the password or change your login password in the Fortify on Demand Portal"
            }

            # TODO: add some more

            ratelimited = @{
                Message = "FOD API rate-limit exceeded."
                RecommendedAction = "Try again in a few moments."
            }
        }
    }

    process {
        If ($ResponseObject.ok)
        {
            # We weren't actually given an error in this case
            Write-Debug "Parse-FODError: Received non-error response, skipping."
            return
        }

        $ErrorParams = $FODErrorData[$ResponseObject.error]

        If ($ErrorParams -eq $null)
        {
            $ErrorParams = @{
                Message = "Unknown error $( $ResponseObject.error ) received from FOD API."
            }
        }
        If ($Exception)
        {
            $ErrorParams.Exception = $Exception
        }

        Write-Error -ErrorId $ResponseObject.error @ErrorParams
    }

    end {
    }
}
