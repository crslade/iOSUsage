# iOSUsage

`iOSUsage` is a MacOS app that reads the screentime usage stats from the MacOS database and exports it in CSV format or uploads the data in JSON format to a Web API. This app is intended to help researchers extract ScreenTime data from iOS devices (iPhones or iPads). 

<img width="901" alt="iOSUsage App" src="https://github.com/crslade/iOSUsage/assets/813401/489e1fbb-7941-48ec-9acd-3d32c8e9449b">

## Installation

Download the DMG from the releases, then drag `iOSUsage` to your application folder.

## Recommended Usage

Please remember the privacy of your participants and do all you can to ensure their privacy. It is recommended that you create a new Apple ID to associate with the iOS device to limit your access to other private data.

### Login the device to an Apple ID and Enable ScreenTime

If not already done, make sure the iPhone or iPad is logged in to an iCloud account with an Apple ID. Then go to Settings -> Screen Time and make sure it is enabled. Also, make sure "Share Across Devices" is enabled.

If you are using a research Mac, using an admin account, install the iOSUsage App by downloading it from the releases.

On the research Mac, you can create a new user account (see image below) to sync screen time data, and then extract the data from that account. To create an account, use an Admin account on the research Mac and go to Settings -> Users & Groups -> Add User. Make sure the new account is a "Standard" account.

<img width="715" alt="How to Create a User Account" src="https://github.com/crslade/iOSUsage/assets/813401/a5dc1560-0b17-4582-8e17-1d76ff1a0588">

After creating the user account (making sure the participant sets the password to ensure privacy), shut off all iCloud services by going to Settings -> (Apple ID) -> iCloud (Click Show All). Turn off all services using iCloud.

<img width="722" alt="Turn off all iCloud services" src="https://github.com/crslade/iOSUsage/assets/813401/52c08af0-fd32-4e80-8b9d-bed52f565710">

Then, on the Mac, go to Settings -> Screen Time and enable screen time. Then make sure the "Share across devices" is turned on.

<img width="717" alt="Turn on Screen time and share across devices" src="https://github.com/crslade/iOSUsage/assets/813401/85515c84-04e0-4581-aca6-6e0429b61b4e">.

Next, on the Mac, go to Settings -> Screen Time -> App & Website Activity. You might need to wait a little while (5-10 minutes) for data to sync between devices. You should see the iOS device in the list of devices.

<img width="803" alt="Let Screen Time data sync" src="https://github.com/crslade/iOSUsage/assets/813401/14f68a8d-a8a0-4fa9-a6f3-4a3199509762">

After the Data has Synced, copy the Screen Time Database from /Users/Account/Library/Application Support/Knowledge to a folder on the Desktop or Documents. To find the folder, you must show hidden files. With the Finder as the active window, press Shift-CMD-. (period). Once you find the database, right-click on Knowledge.db and copy, go to the destination folder on the desktop, right-click, and "paste item".

<img width="1304" alt="Find the Screen Time Data" src="https://github.com/crslade/iOSUsage/assets/813401/046f91ab-b00d-4ca5-95dc-ec429adc8d14">

Then open the iOSUsage app. Select the folder containing the copied knowledge.db file. You can select different devices and make sure you have the right device selected. Then you can export the file by entering the participant id.

### Uploading data to an API

You can upload the data to an API in JSON format. Enter the API endpoint and participant ID.
