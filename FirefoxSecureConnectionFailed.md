# Firefox Secure Connection Failed

Usually if the cert is not valid you can bypass using the Advanced option; however, for CentOS Firefox there was no Advanced option to bypass.

## Tried Adjusting Security

In about:config

Changed security.ssl.enable_ocsp_stapling to false.

Did not help

## Yum update

Installed latest packages and upgraded firefox.

Did not help

## Solution that worked

- Open Help -> Troubleshooting Information

- Under Application Basics selected Open Directory

- Deleted cert8.db file

- Restarted Firefox

Now I have Advanced option.

Not sure if the Security Adjustment and yum update were part of the work around. 

