# Audible Splitter

This is a way of extracting audible audiobook files onto a device that doesn't support Audible. NOTE: This is not endorsed in any way, as you are technically removing the DRM which is against Amazon policies. Use at your own risk!

## Background

I'm a big fan of audibooks, and for a long time I've purchased them and put them onto a cheap MP3 player for my kids to listen to which helps them sleep at night. In the past I'd rip CDs, but in the present, where physical media is hard to come by, I've needed to buy them from Audible. This is fine (Amazon ethics and working practices aside) but my kids are too young to have a phone, and so I can't have them running the audible app now can I? So this Powershell script removed the DRM, splits the file into chapters, and creates an M3U playlist which I need for my cheap MP3 player I'm running.

## Retrieving Your Audiobook

I'm sure this is probably possible on Macs/Linux, but I'm running Windows, so the instructions are also for Windows. 

- Download the AudibleSync App
- Sign in, ensuring that your region is set appropriately where prompted
- Download your Audiobooks
- If you're running default settings the files will be in C:\Users\<Username>\AppData\Roaming\AudibleSync\downloads

## Retrieving Your Activation Bytes

You will first need to extract your "activation Bytes" - which you can find by using this excellent tool here:

https://audible-converter.ml/

Once again, not endorsed in any way, use at your own risk.

## Extracting Your DRM Free Audiobook

Download the script "convert-audiobook.ps1" to the same folder you are storing your downloaded audiobook files, run it, and follow the prompts. That should be all you need to do. If you want to perform this in bulk (like I do because my computer is S-L-O-W then simply download the "convert-all-aax-files.ps1" file as well, and it running that in the same directory will convert all audiobooks found in that directory. Metadata is used to ensure that the file is named accordingly, and split into chapters to help mark your place.

Enjoy! But also don't, because legal ramifications.