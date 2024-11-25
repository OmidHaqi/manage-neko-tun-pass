### Manage nekoray tun mode pass

This script manages **`tun mode`** in **Nekoray** by updating Polkit rules. You can: 
 
1. Enable **tun mode** without a password.  
2. Require a password for **tun mode**.

---

### How to Use
1. Clone the repo

   ```bash
   git clone https://github.com/omidhaqi/manage-neko-tun-pass.git && cd manage-neko-tun-pass
   ``` 

2. Make the script executable:  
   ```bash
   chmod +x manage.sh
   ```
3. Run it:  
   ```bash
   sudo ./manage.sh
   ```
4. Choose:  
   - **1**: No password for **tun mode**.  
   - **2**: Password required for **tun mode**.

The script restarts Polkit to apply changes.  

That’s it!