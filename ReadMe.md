#Verify ComputerName, LocalHostName and HostName.

###This script will :

- Verify `ComputerName` does not contains any parenthesis (2), (3), etc... and remove those if so.
- Compare if `LocalHostName` matches `ComputerName` and if not match them.
- Check if `HostName` is empty or not in the type `ComputerName.mydomain.com`, and will set it up.

You need to edit the `myDomain` variable if you want to set `HostName`.
