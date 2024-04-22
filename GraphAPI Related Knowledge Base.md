# Unsupported Filter value
https://learn.microsoft.com/en-us/graph/aad-advanced-queries?tabs=http
# Note
For advanced filter options, if the response shows "unsupported query", then try following format add  **&$count=true** and add header attr **ConsistencyLevel:eventual**

```powershell
 GET https://graph.microsoft.com/v1.0/users/?$filter=onPremisesSamAccountName eq 'username'&$count=true
```
