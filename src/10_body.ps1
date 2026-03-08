$script:Summary = [ordered]@{}
$script:Diagnosis = New-Object System.Collections.Generic.List[string]
$script:Suggestions = New-Object System.Collections.Generic.List[string]
$script:Details = New-Object System.Collections.Generic.List[string]
$script:AIDevelopment = New-Object System.Collections.Generic.List[string]
$script:SecretLoadError = "<empty>"
$script:SecretSaveError = "<empty>"

# Source of truth lives in the development root script.
# This file exists so agents can evolve toward a split-source layout
# without changing the end-user release model.
