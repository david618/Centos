# User Management

Commands
- Get Date 180 days in the future: `date +%Y-%m-%d -d +180days`
- Set Password Expiration 30 days in future for user1: `sudo chage -E $(date +%Y-%m-%d -d +90days) user1`
- Set Max Days password is valid for user2: `sudo chage -M 15 user2`
- Expire user3's password; must change on next login: `sudo chage -d 0 sspade`
