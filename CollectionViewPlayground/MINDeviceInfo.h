// Copyright 2010-2014 Mineus. All rights reserved.



/*!
 @function MINDeviceSystemVersion
 @abstract Get iOS version
 */
NSString *MINDeviceSystemVersion( void );

int MINDeviceSystemVersionMajor( void );

/*!
 @function MINDeviceModel
 @abstract Get the device model.
 Example: "iPhone 4"
 */
NSString *MINDeviceModel(void);

/*!
 @function MINDeviceModelId
 @abstract Get device's model ID.
 
 This function is more specific than MINDeviceModel()
 
 Examples:
 "x86_64" is the simulator
 "iPod2,1" is 2nd gen iPod
 "iPhone1,2" is iPhone 3G
 "iPhone3,1" is iPhone 4
 "iPhone3,2" is iPhone 4
 "iPhone4,1" is iPhone 4S
 "iPad2,1" is iPad 2 WiFi
 (See http://stackoverflow.com/a/3950748/35440 for more)
 */
NSString *MINDeviceModelId(void);

/*!
 @function MINDeviceUserInterfaceIdiom
 @abstract Get the user interface idiom.
 Example: "Phone" or "Pad".
 Note: iPhone-only apps running on iPad will return "Phone"!
 */
NSString *MINDeviceUserInterfaceIdiom(void);

/*!
 @function MINDeviceDiskSpaceFreeBytes
 @abstract Get available space on disk in bytes
 */
NSString *MINDeviceDiskSpaceFreeBytes(void);

/*!
 @function MINDeviceDiskSpaceFreeBytesInt
 @abstract Get available space on disk in bytes, as an unsigned integer. Returns UINT64_MAX on error.
 */
uint64_t MINDeviceDiskSpaceFreeBytesInt(void);

/*!
 @function MINDeviceDiskSpaceTotalBytes
 @abstract Get total size of disk in bytes
 */
NSString *MINDeviceDiskSpaceTotalBytes(void);

/*!
 @function MINDeviceCurrentLocale
 @abstract Get current locale (or "Region format" in Settings) of the device.
 This setting can be used for formatting date/time etc.
 Example: "Czech (Czech republic)" or "Cherokee (United States)"
 */
NSString *MINDeviceCurrentLocale(void);

/*!
 @function MINDevicePreferredLanguage
 @abstract Get the preferred language of the device. Example: "English"
 */
NSString *MINDevicePreferredLanguage(void);

/*!
 @function MINDeviceSystemTimezone
 @abstract Get the timezone currently used by the system
 */
NSString *MINDeviceSystemTimezone(void);

/*!
 @function MINDeviceCurrentTime
 @abstract Get the current time as returned by [NSDate date].
 */
NSString *MINDeviceCurrentTime(void);

/*!
 @function MINDeviceCurrentTimeLocal
 @abstract Get the current local time formatted using the current region setting.
 */
NSString *MINDeviceCurrentTimeLocal(void);

/*!
 @function MINDeviceIPAddress
 @abstract Get the current IP address of the device or 0.0.0.0 on error.
 */
NSString *MINDeviceIPAddress(void);

/*!
 @function MINDeviceMacAddress
 @abstract Get the MAC address of the device's network interface or an empty string on error
 */
NSString *MINDeviceMacAddress(void);

/*!
 @function MINDeviceJailbroken
 @abstract Try to detect if the device is jailbroken by accessing a file outside the app sandbox.
 */
BOOL MINDeviceJailbroken(void);

/*!
 @function MINIsPad
 @abstract Return YES if the device is an iPad
 */
BOOL MINIsPad(void);

/*!
 @function MINIsPad
 @abstract Return YES if the device is an iPad
 */
BOOL MINIsRetina(void);


/*!
 @function MINIsTallScreen
 @abstract Return YES if the device is an iPhone with the new large screen size
 */
BOOL MINIsTallScreen(void);
